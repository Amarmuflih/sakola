import 'dart:convert';

SignIn signInFromJson(String str) => SignIn.fromJson(json.decode(str));
String signInToJson(SignIn data) => json.encode(data.toJson());

class SignIn {
  String? accessToken;
  String? tokenType;
  DateTime? expiresAt;
  Data? data;
  String? error;

  SignIn({this.accessToken, this.tokenType, this.expiresAt, this.data});

  factory SignIn.fromJson(Map<String, dynamic> json) => SignIn(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresAt: json["expires_at"] == null
        ? null
        : DateTime.parse(json["expires_at"]),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "expires_at": expiresAt?.toIso8601String(),
    "data": data?.toJson(),
  };

  SignIn.withError(String e) : error = e;
}

class Data {
  String? id;
  String? name;
  String? email;
  String? phone;
  dynamic type;
  dynamic emailVerifiedAt;
  dynamic rememberToken;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic associationId;
  bool? isHold;
  List<UserCompany>? userCompanies;

  Data({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.type,
    this.emailVerifiedAt,
    this.rememberToken,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.associationId,
    this.isHold,
    this.userCompanies,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    type: json["type"],
    emailVerifiedAt: json["email_verified_at"],
    rememberToken: json["remember_token"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    associationId: json["association_id"],
    isHold: json["is_hold"],
    userCompanies: json["user_companies"] == null
        ? []
        : List<UserCompany>.from(
            json["user_companies"]!.map((x) => UserCompany.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "type": type,
    "email_verified_at": emailVerifiedAt,
    "remember_token": rememberToken,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "association_id": associationId,
    "is_hold": isHold,
    "user_companies": userCompanies == null
        ? []
        : List<dynamic>.from(userCompanies!.map((x) => x.toJson())),
  };
}

class UserCompany {
  String? id;
  String? companyId;
  String? userId;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? type;
  Company? company;

  UserCompany({
    this.id,
    this.companyId,
    this.userId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.company,
  });

  factory UserCompany.fromJson(Map<String, dynamic> json) => UserCompany(
    id: json["id"],
    companyId: json["company_id"],
    userId: json["user_id"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    type: json["type"],
    company: json["company"] == null ? null : Company.fromJson(json["company"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "user_id": userId,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "type": type,
    "company": company?.toJson(),
  };
}

class Company {
  String? id;
  String? userId;
  String? name;
  dynamic address;
  dynamic phone;
  String? city;
  dynamic email;
  dynamic taxIdNumber;
  dynamic taxIdAddress;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? businessType;
  int? mainProjectQuota;
  int? mainLotQuota;
  int? isStorefront;
  dynamic domain;
  dynamic subdomain;
  int? storefrontProjectQuota;
  String? numberOfStudents;

  Company({
    this.id,
    this.userId,
    this.name,
    this.address,
    this.phone,
    this.city,
    this.email,
    this.taxIdNumber,
    this.taxIdAddress,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.businessType,
    this.mainProjectQuota,
    this.mainLotQuota,
    this.isStorefront,
    this.domain,
    this.subdomain,
    this.storefrontProjectQuota,
    this.numberOfStudents,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    address: json["address"],
    phone: json["phone"],
    city: json["city"],
    email: json["email"],
    taxIdNumber: json["tax_id_number"],
    taxIdAddress: json["tax_id_address"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    businessType: json["business_type"],
    mainProjectQuota: json["main_project_quota"],
    mainLotQuota: json["main_lot_quota"],
    isStorefront: json["is_storefront"],
    domain: json["domain"],
    subdomain: json["subdomain"],
    storefrontProjectQuota: json["storefront_project_quota"],
    numberOfStudents: json["number_of_students"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "address": address,
    "phone": phone,
    "city": city,
    "email": email,
    "tax_id_number": taxIdNumber,
    "tax_id_address": taxIdAddress,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "business_type": businessType,
    "main_project_quota": mainProjectQuota,
    "main_lot_quota": mainLotQuota,
    "is_storefront": isStorefront,
    "domain": domain,
    "subdomain": subdomain,
    "storefront_project_quota": storefrontProjectQuota,
    "number_of_students": numberOfStudents,
  };
}
