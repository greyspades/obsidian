class DepOfficer {
  final String? ref;
  final String? name;
  final String? title;

  DepOfficer(
      {required this.ref, required this.name, required this.title});

  factory DepOfficer.fromJson(Map<String, dynamic> json) {
    return DepOfficer(
        ref: json['ItemCode'],
        name: json['ItemName'],
        title: json['JFName']);
  }
}
