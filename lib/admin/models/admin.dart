class Admin {
  String? adminAvatarUrl;
  String? adminEmail;
  String? adminName;
  String? adminPassword;
  int? adminPhone;
  String? adminRole;
  String? adminUID;
  int? adminEarnings;
  String? adminStatus;

  Admin({
    this.adminAvatarUrl,
    this.adminEmail,
    this.adminName,
    this.adminPassword,
    this.adminPhone,
    this.adminRole,
    this.adminUID,
    this.adminEarnings,
    this.adminStatus,
  });

  Admin.fromJson(Map<String, dynamic> json) {
    adminAvatarUrl = json["AdminAvatarUrl"];
    adminEmail = json["AdminEmail"];
    adminName = json["AdminName"];
    adminPassword = json["AdminPassword"];
    adminPhone = json["AdminPhone"];
    adminRole = json["AdminRole"];
    adminUID = json["AdminUID"];
    adminEarnings = json["AdminEarnings"];
    adminStatus = json["AdminStatus"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["AdminAvatarUrl"] = adminAvatarUrl;
    data["AdminEmail"] = adminEmail;
    data["AdminName"] = adminName;
    data["AdminPassword"] = adminPassword;
    data["AdminPhone"] = adminPhone;
    data["AdminRole"] = adminRole;
    data["AdminUID"] = adminUID;
    data["AdminEarnings"] = adminEarnings;
    data["AdminStatus"] = adminStatus;
    return data;
  }
}
