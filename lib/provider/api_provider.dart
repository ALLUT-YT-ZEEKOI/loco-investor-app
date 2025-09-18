import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:investorapp/provider/objects.dart';

class ApiProvider with ChangeNotifier {
  // Constants
  static const String _domain = "https://sandbox.locorides.com";
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const int _defaultCountryCode = 91;
  static const Duration _requestTimeout = Duration(seconds: 30);

  // State variables
  String? _phonenumber;
  bool _isLoading = false;
  final int _countrycode = _defaultCountryCode;

  // Cache is disabled - removed cache variables

  // Getters
  String? get phonenumber => _phonenumber;
  bool get isLoading => _isLoading;
  int get countrycode => _countrycode;

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<String?> _getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Map<String, String> _getAuthHeaders(String token) {
    return {'Authorization': 'Bearer $token'};
  }

  Future<http.Response> _makeRequest(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    String method = 'GET',
  }) async {
    final url = Uri.parse('$_domain$endpoint');

    switch (method.toUpperCase()) {
      case 'POST':
        return await http.post(url, headers: headers, body: body).timeout(_requestTimeout);
      case 'PUT':
        return await http.put(url, headers: headers, body: body).timeout(_requestTimeout);
      case 'DELETE':
        return await http.delete(url, headers: headers).timeout(_requestTimeout);
      default:
        return await http.get(url, headers: headers).timeout(_requestTimeout);
    }
  }

  bool _isCacheValid(DateTime? lastFetch, {Duration maxAge = const Duration(minutes: 5)}) {
    // Disable cache - always return false to force fresh data
    return false;
  }

  // Public methods
  void setPhoneNumber(String phoneNumber) {
    _phonenumber = phoneNumber;
    notifyListeners();
  }

  Future<Either<bool, String>> getOtp() async {
    if (_phonenumber == null) {
      return right('Phone number is required');
    }

    try {
      final response = await _makeRequest(
        '/api/login',
        method: 'POST',
        body: {'phone': _phonenumber!, 'country_code': '+$_countrycode'},
      );

      if (response.statusCode == 200) {
        return left(true);
      } else {
        final errorData = jsonDecode(response.body);
        return right(errorData['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      return right("Network error: $e");
    }
  }

  Future<Either<bool, String>> submitOtp(String otp) async {
    if (_phonenumber == null) {
      return right('Phone number is required');
    }

    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final os = Platform.isAndroid ? 'android' : 'ios';

      final response = await _makeRequest(
        '/api/login/otp-verify',
        method: 'POST',
        body: {'phone': _phonenumber!, 'country_code': '+$_countrycode', 'otp': otp, 'fcm': fcmToken ?? '', 'app_code': 'investor_app', 'app_os': os},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData.containsKey('token')) {
        await _storage.write(key: 'auth_token', value: responseData['token']);

        return left(true);
      } else {
        return right(responseData['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      return right("Network error: $e");
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _storage.delete(key: 'auth_token');
      _clearCache();
    } finally {
      _setLoading(false);
    }
  }

  void _clearCache() {
    // Cache is disabled - no cache to clear
  }

  // Data properties
  List<Asset> getAssets = [];
  List<Asset> allAssets = [];
  String currentMonthFilter = 'this_month';
  User? currentUser;

  Future<Either<bool, String>> getAllAssets({String? startDate, String? endDate, bool forceRefresh = false}) async {
    // Cache is disabled - always fetch fresh data
    // Always show loading state (including during pull-to-refresh)
    _setLoading(true);

    try {
      final token = await _getAuthToken();
      if (token == null) {
        return right('No authentication token found');
      }

      // Build endpoint with optional date parameters
      String endpoint = '/api/investor/assets/all';
      if (startDate != null && endDate != null) {
        endpoint += '?start_date=$startDate&end_date=$endDate';
      }

      final response = await _makeRequest(
        endpoint,
        headers: _getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(responseData);

        getAssets = apiResponse.assets;

        if (startDate == null && endDate == null) {
          allAssets = List.from(apiResponse.assets);
        }

        if (startDate != null && endDate != null) {
        } else {}

        return left(true);
      } else {
        final errorMsg = 'Failed to load assets: ${response.statusCode}';

        return right(errorMsg);
      }
    } catch (e) {
      final errorMsg = 'Error loading assets: $e';

      return right(errorMsg);
    } finally {
      // Always hide loading state
      _setLoading(false);
    }
  }

  // Date utility methods
  Map<String, String> _getCurrentMonthRange() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    return {
      'start': _formatDate(firstDay),
      'end': _formatDate(lastDay),
    };
  }

  Map<String, String> _getLastMonthRange() {
    final now = DateTime.now();
    final firstDayLastMonth = DateTime(now.year, now.month - 1, 1);
    final lastDayLastMonth = DateTime(now.year, now.month, 0);

    return {
      'start': _formatDate(firstDayLastMonth),
      'end': _formatDate(lastDayLastMonth),
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Filter methods
  Future<Either<bool, String>> filterAssetsByMonth(String monthType) async {
    currentMonthFilter = monthType;

    // Load all assets first if not already loaded (for lifetime calculations)
    if (allAssets.isEmpty) {
      final result = await getAllAssets();
      if (result.isRight()) {
        return result;
      }
    }

    Map<String, String>? dateRange;
    switch (monthType) {
      case 'this_month':
        dateRange = _getCurrentMonthRange();
        break;
      case 'last_month':
        dateRange = _getLastMonthRange();
        break;
      default:
        return await getAllAssets();
    }

    return await getAllAssets(
      startDate: dateRange['start'],
      endDate: dateRange['end'],
    );
  }

  Future<Either<bool, String>> getUser({bool forceRefresh = false}) async {
    // Cache is disabled - always fetch fresh data
    // Always show loading state (including during pull-to-refresh)
    _setLoading(true);

    try {
      final token = await _getAuthToken();
      if (token == null) {
        return right('No authentication token found');
      }

      final response = await _makeRequest(
        '/api/user',
        headers: _getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userResponse = UserResponse.fromJson(responseData);

        if (userResponse.success) {
          currentUser = userResponse.user;

          return left(true);
        } else {
          return right('Failed to get user data');
        }
      } else {
        final errorMsg = 'Failed to get user: ${response.statusCode}';

        return right(errorMsg);
      }
    } catch (e) {
      final errorMsg = 'Error getting user: $e';

      return right(errorMsg);
    } finally {
      // Always hide loading state
      _setLoading(false);
    }
  }

  List<Deduction> allDeductions = [];
  DeductionsData? deductionsData;

  // Transaction history data
  List<Transaction> allTransactions = [];
  TransactionHistoryData? transactionHistoryData;

  Future<Either<bool, String>> getAllDeductions({
    int page = 1,
    String? startDate,
    String? endDate,
    bool forceRefresh = false,
  }) async {
    // Cache is disabled - always fetch fresh data
    // Always show loading state (including during pull-to-refresh)
    _setLoading(true);

    try {
      final token = await _getAuthToken();
      if (token == null) {
        return right('No authentication token found');
      }

      // Build endpoint with optional date parameters
      String endpoint = '/api/investor/deductions?page=$page';
      if (startDate != null && endDate != null) {
        endpoint += '&start_date=$startDate&end_date=$endDate';
      }

      final response = await _makeRequest(
        endpoint,
        headers: _getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final deductionsResponse = DeductionsResponse.fromJson(responseData);

        if (deductionsResponse.success) {
          deductionsData = deductionsResponse.deductions;
          allDeductions = deductionsResponse.deductions.data;

          return left(true);
        } else {
          return right('Failed to get deductions data');
        }
      } else {
        final errorMsg = 'Failed to get deductions: ${response.statusCode}';

        return right(errorMsg);
      }
    } catch (e) {
      final errorMsg = 'Error getting deductions: $e';

      return right(errorMsg);
    } finally {
      // Always hide loading state
      _setLoading(false);
    }
  }

  Future<Either<bool, String>> getAllTransactions({int page = 1, String? startDate, String? endDate, bool forceRefresh = false}) async {
    // Cache is disabled - always fetch fresh data
    // Always show loading state (including during pull-to-refresh)
    _setLoading(true);

    try {
      final token = await _getAuthToken();
      if (token == null) {
        return right('No authentication token found');
      }

      // Build endpoint with optional date parameters
      String endpoint = '/api/investor/transactionHistory?page=$page';
      if (startDate != null && endDate != null) {
        endpoint += '&start_date=$startDate&end_date=$endDate';
      }

      final response = await _makeRequest(
        endpoint,
        headers: _getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final transactionResponse = TransactionHistoryResponse.fromJson(responseData);

        if (transactionResponse.msg.isNotEmpty) {
          transactionHistoryData = transactionResponse.data;
          allTransactions = transactionResponse.data.data;

          return left(true);
        } else {
          return right('Failed to get transaction history data');
        }
      } else {
        final errorMsg = 'Failed to get transaction history: ${response.statusCode}';

        return right(errorMsg);
      }
    } catch (e) {
      final errorMsg = 'Error getting transaction history: $e';

      return right(errorMsg);
    } finally {
      // Always hide loading state
      _setLoading(false);
    }
  }

  // Filter methods
  Future<Either<bool, String>> filterDeductionsByMonth(String monthType) async {
    currentMonthFilter = monthType;

    Map<String, String>? dateRange;
    switch (monthType) {
      case 'this_month':
        dateRange = _getCurrentMonthRange();
        break;
      case 'last_month':
        dateRange = _getLastMonthRange();
        break;
      default:
        return await getAllDeductions();
    }

    return await getAllDeductions(
      startDate: dateRange['start'],
      endDate: dateRange['end'],
    );
  }

  Future<Either<bool, String>> filterTransactionsByMonth(String monthType) async {
    currentMonthFilter = monthType;

    Map<String, String>? dateRange;
    switch (monthType) {
      case 'this_month':
        dateRange = _getCurrentMonthRange();
        break;
      case 'last_month':
        dateRange = _getLastMonthRange();
        break;
      default:
        return await getAllTransactions();
    }

    return await getAllTransactions(
      startDate: dateRange['start'],
      endDate: dateRange['end'],
    );
  }

  // Utility methods
  void clearCache() {
    // Cache is disabled - no cache to clear
  }

  void forceRefreshAll() {
    // Trigger refresh of all data (cache is disabled, so this just calls the APIs)
    getAllAssets(forceRefresh: true);
    getUser(forceRefresh: true);
    getAllDeductions(forceRefresh: true);
    getAllTransactions(forceRefresh: true);
  }
}
