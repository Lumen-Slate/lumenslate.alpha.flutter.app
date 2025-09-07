class LumenUser {
  final String id;
  final String name;
  final String email;
  final String? role;
  final String? phone;
  final String? photoUrl;

  LumenUser({this.photoUrl, required this.role, required this.id, required this.name, required this.email, required this.phone});

  factory LumenUser.fromJson(Map<String, dynamic> json) {
    return LumenUser(id: json['id'], name: json['name'], email: json['email'], role: json['role'], phone: json['phone'], photoUrl: json['photoUrl']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'role': role, 'phone': phone, 'photoUrl': photoUrl};
  }

  LumenUser copyWith({String? id, String? name, String? email,
      String? role, String? phone, String? photoUrl}) {
    return LumenUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
