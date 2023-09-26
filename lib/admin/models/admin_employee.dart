class AdminEmployee {
  String? employeeAvatarUrl;
  String? employeeEmail;
  String? employeeName;
  String? employeePassword;
  int? employeePhone;
  String? employeeRole;
  String? employeeUID;
  double? employeeEarnings;
  String? employeeStatus;


  AdminEmployee({
    this.employeeAvatarUrl,
    this.employeeEmail,
    this.employeeName,
    this.employeePassword,
    this.employeePhone,
    this.employeeRole,
    this.employeeUID,
    this.employeeEarnings,
    this.employeeStatus,
  });

  AdminEmployee.fromJson(Map<String, dynamic> json) {
    employeeAvatarUrl = json["EmployeeAvatarUrl"];
    employeeEmail = json["EmployeeEmail"];
    employeeName = json["EmployeeName"];
    employeePassword = json["EmployeePassword"];
    employeePhone = json["EmployeePhone"];
    employeeRole = json["EmployeeRole"];
    employeeUID = json["EmployeeUID"];
    employeeEarnings = json["EmployeeEarnings"];
    employeeStatus = json["EmployeeStatus"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["EmployeeAvatarUrl"] = employeeAvatarUrl;
    data["EmployeeEmail"] = employeeEmail;
    data["EmployeeName"] = employeeName;
    data["EmployeePassword"] = employeePassword;
    data["EmployeePhone"] = employeePhone;
    data["EmployeeRole"] = employeeRole;
    data["EmployeeUID"] = employeeUID;
    data["EmployeeEarnings"] = employeeEarnings;
    data["EmployeeStatus"] = employeeStatus;
    return data;
  }
  factory AdminEmployee.fromFirestore(Map<String, dynamic> json) {
    return AdminEmployee(
      employeeAvatarUrl: json["EmployeeAvatarUrl"],
      employeeEmail: json["EmployeeEmail"],
      employeeName: json["EmployeeName"],
      employeePassword: json["EmployeePassword"],
      employeePhone: json["EmployeePhone"],
      employeeRole: json["EmployeeRole"],
      employeeUID: json["EmployeeUID"],
      employeeEarnings: json["EmployeeEarnings"],
      employeeStatus: json["EmployeeStatus"],
    );
  }

}
