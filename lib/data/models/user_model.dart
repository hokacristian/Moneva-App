class User {
  final String email;
  final String name;
  final String role;

  User({
    required this.email,
    required this.name,
    required this.role,
  });

  // Factory method untuk membuat objek User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }

  // Convert User object ke JSON (untuk penyimpanan atau request API)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'role': role,
    };
  }
}
