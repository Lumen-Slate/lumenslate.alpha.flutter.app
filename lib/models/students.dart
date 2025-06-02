class Students {
  String id;
  String name;
  String email;
  String rollNo;
  List<String> classIds;

  Students({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNo,
    required this.classIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rollNo': rollNo,
      'classIds': classIds,
    };
  }

  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      rollNo: json['rollNo'],
      classIds: json['classIds'],
    );
  }
}