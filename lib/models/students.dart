class Student {
  String id;
  String name;
  String email;
  String rollNo;
  List<String> classIds;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isActive;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNo,
    required this.classIds,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rollNo': rollNo,
      'classIds': classIds,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      rollNo: json['rollNo'],
      classIds: List<String>.from(json['classIds']),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'],
    );
  }
}