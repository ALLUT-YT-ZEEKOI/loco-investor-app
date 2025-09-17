import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:investorapp/provider/objects.dart';

class ApiProvider with ChangeNotifier {
  final String domain = "https://sandbox.locorides.com";
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  String? phonenumber;
  bool isLoading = false;
  int countrycode = 91;

  void setPhoneNumber(String phoneNumber) {
    phonenumber = phoneNumber;
    notifyListeners();
  }

  Future<void> getOtp() async {
    if (phonenumber == null) return;
    final url = Uri.parse('$domain/api/login');
    final body = {'phone': phonenumber, 'country_code': '+$countrycode'};
    try {
      final response = await http.post(url, body: body);
      print("OTP Response: ${response.body}");
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  Future<Either<bool, String>> submitOtp(String otp) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('📱 FCM Token: $fcmToken');
    final os = Platform.isAndroid ? 'android' : 'ios';

    final url = Uri.parse('$domain/api/login/otp-verify');
    final body = {
      'phone': phonenumber,
      'country_code': '+$countrycode',
      'otp': otp,
      'fcm': fcmToken ?? '',
      'app_code': 'investor_app',
      'app_os': os
    };
    print(body);

    try {
      final response = await http.post(url, body: body);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData.containsKey('token')) {
        print(responseData['token']);

        await storage.write(key: 'auth_token', value: responseData['token']);
        return left(true);
      } else {
        return right(responseData['message'] ?? 'OTP verification failed.');
      }
    } catch (e) {
      return right("Error verifying OTP: $e");
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();
    try {
      await storage.delete(key: 'auth_token');
    } catch (e) {
      print("Logout error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  List<Asset> getAssets = [];
  List<Asset> allAssets = []; // Store all assets for lifetime calculations
  String currentMonthFilter = 'this_month'; // Track current filter

  Future<void> getAllAssets({String? startDate, String? endDate}) async {
    isLoading = true;
    notifyListeners();

    try {
      String? token = await storage.read(key: 'auth_token');
      if (token == null) {
        return;
      }

      // Build URL with optional date parameters
      String urlString = '$domain/api/investor/assets/all';
      if (startDate != null && endDate != null) {
        urlString += '?start_date=$startDate&end_date=$endDate';
      }

      final url = Uri.parse(urlString);
      final headers = {'Authorization': 'Bearer $token'};
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Use the ApiResponse class for proper parsing
        ApiResponse apiResponse = ApiResponse.fromJson(responseData);
        getAssets = apiResponse.assets;

        
        if (startDate == null && endDate == null) {
          allAssets = List.from(apiResponse.assets);
        }

        print('Successfully loaded ${getAssets.length} assets');
        if (startDate != null && endDate != null) {
          print('Filtered by date range: $startDate to $endDate');
        } else {
          print('Loaded all assets for lifetime calculations');
        }
      } else {
        print('Failed to load assets: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error loading assets: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<String, String> _getCurrentMonthRange() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    return {
      'start':
          '${firstDay.year.toString().padLeft(4, '0')}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}',
      'end':
          '${lastDay.year.toString().padLeft(4, '0')}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}',
    };
  }

  // Helper method to get date range for last month
  Map<String, String> _getLastMonthRange() {
    final now = DateTime.now();
    final firstDayLastMonth = DateTime(now.year, now.month - 1, 1);
    final lastDayLastMonth = DateTime(now.year, now.month, 0);

    return {
      'start':
          '${firstDayLastMonth.year.toString().padLeft(4, '0')}-${firstDayLastMonth.month.toString().padLeft(2, '0')}-${firstDayLastMonth.day.toString().padLeft(2, '0')}',
      'end':
          '${lastDayLastMonth.year.toString().padLeft(4, '0')}-${lastDayLastMonth.month.toString().padLeft(2, '0')}-${lastDayLastMonth.day.toString().padLeft(2, '0')}',
    };
  }

  // Method to filter assets by month
  Future<void> filterAssetsByMonth(String monthType) async {
    currentMonthFilter = monthType;

    // Load all assets first if not already loaded (for lifetime calculations)
    if (allAssets.isEmpty) {
      await getAllAssets();
    }

    if (monthType == 'this_month') {
      final dateRange = _getCurrentMonthRange();
      await getAllAssets(
          startDate: dateRange['start'], endDate: dateRange['end']);
    } else if (monthType == 'last_month') {
      final dateRange = _getLastMonthRange();
      await getAllAssets(
          startDate: dateRange['start'], endDate: dateRange['end']);
    } else {
      // Load all assets without date filter
      await getAllAssets();
    }
  }

  User? currentUser; // Store current user data

  Future<Either<bool, String>> getUser() async {
    isLoading = true;
    notifyListeners();

    try {
      String? token = await storage.read(key: 'auth_token');
      if (token == null) {
        isLoading = false;
        notifyListeners();
        return right('No authentication token found');
      }

      final url = Uri.parse('$domain/api/user');
      final headers = {'Authorization': 'Bearer $token'};
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Parse the response using UserResponse class
        UserResponse userResponse = UserResponse.fromJson(responseData);

        if (userResponse.success) {
          currentUser = userResponse.user;
          print('Successfully loaded user: ${currentUser?.name}');
          isLoading = false;
          notifyListeners();
          return left(true);
        } else {
          isLoading = false;
          notifyListeners();
          return right('Failed to get user data');
        }
      } else {
        print('Failed to get user: ${response.statusCode}');
        print('Response: ${response.body}');
        isLoading = false;
        notifyListeners();
        return right('Failed to get user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting user: $e');
      isLoading = false;
      notifyListeners();
      return right('Error getting user data: $e');
    }
  }

  List<Deduction> allDeductions = []; // Store all deductions
  DeductionsData? deductionsData; // Store pagination data

  Future<Either<bool, String>> getAllDeductions(
      {int page = 1, String? startDate, String? endDate}) async {
    isLoading = true;
    notifyListeners();

    try {
      String? token = await storage.read(key: 'auth_token');
      if (token == null) {
        isLoading = false;
        notifyListeners();
        return right('No authentication token found');
      }

      // Build URL with optional date parameters
      String urlString = '$domain/api/investor/deductions?page=$page';
      if (startDate != null && endDate != null) {
        urlString += '&start_date=$startDate&end_date=$endDate';
      }

      final url = Uri.parse(urlString);
      final headers = {'Authorization': 'Bearer $token'};
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Parse the response using DeductionsResponse class
        DeductionsResponse deductionsResponse =
            DeductionsResponse.fromJson(responseData);

        if (deductionsResponse.success) {
          deductionsData = deductionsResponse.deductions;
          allDeductions = deductionsResponse.deductions.data;
          print('Successfully loaded ${allDeductions.length} deductions');
          print('Total deductions: ${deductionsData?.total}');
          if (startDate != null && endDate != null) {
            print('Filtered by date range: $startDate to $endDate');
          } else {
            print('Loaded all deductions');
          }
          isLoading = false;
          notifyListeners();
          return left(true);
        } else {
          isLoading = false;
          notifyListeners();
          return right('Failed to get deductions data');
        }
      } else {
        print('Failed to get deductions: ${response.statusCode}');
        print('Response: ${response.body}');
        isLoading = false;
        notifyListeners();
        return right('Failed to get deductions data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting deductions: $e');
      isLoading = false;
      notifyListeners();
      return right('Error getting deductions data: $e');
    }
  }

  // Method to filter deductions by month
  Future<void> filterDeductionsByMonth(String monthType) async {
    currentMonthFilter = monthType;

    if (monthType == 'this_month') {
      final dateRange = _getCurrentMonthRange();
      await getAllDeductions(
          startDate: dateRange['start'], endDate: dateRange['end']);
    } else if (monthType == 'last_month') {
      final dateRange = _getLastMonthRange();
      await getAllDeductions(
          startDate: dateRange['start'], endDate: dateRange['end']);
    } else {
      // Load all deductions without date filter
      await getAllDeductions();
    }
  }
}
