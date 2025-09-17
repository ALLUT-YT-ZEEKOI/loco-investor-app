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

class DeductionsResponse {
  final bool success;
  final DeductionsData deductions;

  DeductionsResponse({
    required this.success,
    required this.deductions,
  });

  factory DeductionsResponse.fromJson(Map<String, dynamic> json) {
    return DeductionsResponse(
      success: json['success'] ?? false,
      deductions: DeductionsData.fromJson(json['deductions'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'deductions': deductions.toJson(),
    };
  }
}

class DeductionsData {
  final int currentPage;
  final List<Deduction> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  DeductionsData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory DeductionsData.fromJson(Map<String, dynamic> json) {
    return DeductionsData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List<dynamic>?)
              ?.map((deductionJson) => Deduction.fromJson(deductionJson))
              .toList() ??
          [],
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'] ?? '',
      links: (json['links'] as List<dynamic>?)
              ?.map((linkJson) => PageLink.fromJson(linkJson))
              .toList() ??
          [],
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 20,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((deduction) => deduction.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((link) => link.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class Deduction {
  final int id;
  final int businessId;
  final int userId;
  final int assetId;
  final double amount;
  final String status;
  final String transactionDate;
  final String? note;
  final int createdBy;
  final String createdAt;
  final String updatedAt;
  final double ownerShare;
  final double companyShare;
  final int catId;
  final DeductionAsset asset;
  final DeductionCategory cat;

  Deduction({
    required this.id,
    required this.businessId,
    required this.userId,
    required this.assetId,
    required this.amount,
    required this.status,
    required this.transactionDate,
    this.note,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.ownerShare,
    required this.companyShare,
    required this.catId,
    required this.asset,
    required this.cat,
  });

  factory Deduction.fromJson(Map<String, dynamic> json) {
    return Deduction(
      id: json['id'] ?? 0,
      businessId: json['business_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      assetId: json['asset_id'] ?? 0,
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      transactionDate: json['transaction_date'] ?? '',
      note: json['note'],
      createdBy: json['created_by'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      ownerShare: (json['owner_share'] ?? 0.0).toDouble(),
      companyShare: (json['company_share'] ?? 0.0).toDouble(),
      catId: json['cat_id'] ?? 0,
      asset: DeductionAsset.fromJson(json['asset'] ?? {}),
      cat: DeductionCategory.fromJson(json['cat'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'user_id': userId,
      'asset_id': assetId,
      'amount': amount,
      'status': status,
      'transaction_date': transactionDate,
      'note': note,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'owner_share': ownerShare,
      'company_share': companyShare,
      'cat_id': catId,
      'asset': asset.toJson(),
      'cat': cat.toJson(),
    };
  }
}

class DeductionAsset {
  final int id;
  final String assetIdentifier;

  DeductionAsset({
    required this.id,
    required this.assetIdentifier,
  });

  factory DeductionAsset.fromJson(Map<String, dynamic> json) {
    return DeductionAsset(
      id: json['id'] ?? 0,
      assetIdentifier: json['asset_identifier'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asset_identifier': assetIdentifier,
    };
  }
}

class DeductionCategory {
  final int id;
  final String name;
  final String? desc;

  DeductionCategory({
    required this.id,
    required this.name,
    this.desc,
  });

  factory DeductionCategory.fromJson(Map<String, dynamic> json) {
    return DeductionCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      desc: json['desc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
    };
  }
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
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
