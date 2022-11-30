class Staff {
  final String? employeeNo;
  final String? firstName;
  final String? lastName;
  final String? fullNameDot;
  final String? gender;
  final int? uRole;
  final String? roleName;
  final String? buCode;
  final String? buName;
  final String? userRef;

  Staff({required this.employeeNo, required this.firstName, required this.lastName, required this.fullNameDot, required this.gender, required this.uRole, required this.roleName, required this.buCode, required this.buName, required this.userRef});

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      employeeNo: json['Employee_no'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      fullNameDot: json['FullNameDot'],
      gender: json['Gender'],
      uRole: json['uRole'],
      roleName: json['Rol_Name'],
      buCode: json['Bu_Code'],
      buName: json['Bu_Name'],
      userRef: json['UserRef']
    );
  }
}