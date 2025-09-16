class ApiResponse {
  final bool success;
  final List<Asset> assets;

  ApiResponse({
    required this.success,
    required this.assets,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      assets: (json['assets'] as List<dynamic>?)
              ?.map((assetJson) => Asset.fromJson(assetJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'assets': assets.map((asset) => asset.toJson()).toList(),
    };
  }
}

class UserResponse {
  final bool success;
  final User user;

  UserResponse({
    required this.success,
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'] ?? false,
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'user': user.toJson(),
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String countryCode;
  final String country;
  final String phone;
  final String? photo;
  final String type;
  final String? aadharNumber;
  final String? aadharFront;
  final String? aadharBack;
  final int aadharVerified;
  final String? drivingLicenceNumber;
  final String? drivingLicenceFront;
  final String? drivingLicenceBack;
  final int drivingLicenceVerified;
  final String? passportNumber;
  final String? passportFront;
  final String? passportBack;
  final int passportVerified;
  final String status;
  final String? dob;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.country,
    required this.phone,
    this.photo,
    required this.type,
    this.aadharNumber,
    this.aadharFront,
    this.aadharBack,
    required this.aadharVerified,
    this.drivingLicenceNumber,
    this.drivingLicenceFront,
    this.drivingLicenceBack,
    required this.drivingLicenceVerified,
    this.passportNumber,
    this.passportFront,
    this.passportBack,
    required this.passportVerified,
    required this.status,
    this.dob,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      countryCode: json['country_code'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'] ?? '',
      photo: json['photo'],
      type: json['type'] ?? '',
      aadharNumber: json['aadhar_number'],
      aadharFront: json['aadhar_front'],
      aadharBack: json['aadhar_back'],
      aadharVerified: json['aadhar_verified'] ?? 0,
      drivingLicenceNumber: json['driving_licence_number'],
      drivingLicenceFront: json['driving_licence_front'],
      drivingLicenceBack: json['driving_licence_back'],
      drivingLicenceVerified: json['driving_licence_verified'] ?? 0,
      passportNumber: json['passport_number'],
      passportFront: json['passport_front'],
      passportBack: json['passport_back'],
      passportVerified: json['passport_verified'] ?? 0,
      status: json['status'] ?? '',
      dob: json['dob'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'country_code': countryCode,
      'country': country,
      'phone': phone,
      'photo': photo,
      'type': type,
      'aadhar_number': aadharNumber,
      'aadhar_front': aadharFront,
      'aadhar_back': aadharBack,
      'aadhar_verified': aadharVerified,
      'driving_licence_number': drivingLicenceNumber,
      'driving_licence_front': drivingLicenceFront,
      'driving_licence_back': drivingLicenceBack,
      'driving_licence_verified': drivingLicenceVerified,
      'passport_number': passportNumber,
      'passport_front': passportFront,
      'passport_back': passportBack,
      'passport_verified': passportVerified,
      'status': status,
      'dob': dob,
    };
  }
}

class Asset {
  final String name;
  final String assetIdentifier;
  final String image;
  final String type;
  final int id;
  final int assetOwnerId;
  final int businessId;
  final int categoryId;
  final int kmLimit;
  final int speedLimit;
  final dynamic otherDetails; // Changed to dynamic to handle both Map and List
  final String manufacturer;
  final String manufacturerLogo;
  final double ownerProfitAmt;
  final double payoutSum;
  final double deductionSum;
  final int transactionCount;
  final String status;

  Asset({
    required this.name,
    required this.assetIdentifier,
    required this.image,
    required this.type,
    required this.id,
    required this.assetOwnerId,
    required this.businessId,
    required this.categoryId,
    required this.kmLimit,
    required this.speedLimit,
    required this.otherDetails,
    required this.manufacturer,
    required this.manufacturerLogo,
    required this.ownerProfitAmt,
    required this.payoutSum,
    required this.deductionSum,
    required this.transactionCount,
    required this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      name: json['name'] ?? '',
      assetIdentifier: json['asset_identifier'] ?? '',
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      id: json['id'] ?? 0,
      assetOwnerId: json['asset_owner_id'] ?? 0,
      businessId: json['business_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      kmLimit: json['km_limit'] ?? 0,
      speedLimit: json['speed_limit'] ?? 0,
      otherDetails:
          json['other_details'], // Keep as dynamic to handle both Map and List
      manufacturer: json['manufacturer'] ?? '',
      manufacturerLogo: json['manufacturer_logo'] ?? '',
      ownerProfitAmt: (json['owner_profit_amt'] ?? 0.0).toDouble(),
      payoutSum: (json['payout_sum'] ?? 0.0).toDouble(),
      deductionSum: (json['deduction_sum'] ?? 0.0).toDouble(),
      transactionCount: json['transaction_count'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'asset_identifier': assetIdentifier,
      'image': image,
      'type': type,
      'id': id,
      'asset_owner_id': assetOwnerId,
      'business_id': businessId,
      'category_id': categoryId,
      'km_limit': kmLimit,
      'speed_limit': speedLimit,
      'other_details': otherDetails,
      'manufacturer': manufacturer,
      'manufacturer_logo': manufacturerLogo,
      'owner_profit_amt': ownerProfitAmt,
      'payout_sum': payoutSum,
      'deduction_sum': deductionSum,
      'transaction_count': transactionCount,
      'status': status
    };
  }
}
