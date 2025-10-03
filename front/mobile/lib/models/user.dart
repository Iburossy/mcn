class User {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? avatar;
  final String role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.avatar,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'] ?? json['phone'] ?? '',
      email: json['email'],
      avatar: json['avatar'],
      role: json['role'] ?? 'visitor',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'avatar': avatar,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
