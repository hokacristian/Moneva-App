class User {
    final int id; // ✅ Tambahkan id

  final String email;
  final String name;
  final String role;

  User({
        required this.id, // ✅ Pastikan id ada di constructor

    required this.email,
    required this.name,
    required this.role,
  });

  // Factory method untuk membuat objek User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
            id: json['id'], // ✅ Ambil id dari API

      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }

  // Convert User object ke JSON (untuk penyimpanan atau request API)
  Map<String, dynamic> toJson() {
    return {
            'id': id,

      'email': email,
      'name': name,
      'role': role,
    };
  }
}
