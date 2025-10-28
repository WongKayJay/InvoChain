class User {
  final int? id;
  final String email;
  final String passwordHash;
  final String fullName;
  final DateTime createdAt;
  final DateTime? lastLogin;

  User({
    this.id,
    required this.email,
    required this.passwordHash,
    required this.fullName,
    required this.createdAt,
    this.lastLogin,
  });

  // Convert User to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password_hash': passwordHash,
      'full_name': fullName,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  // Create User from Map (database query result)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      email: map['email'] as String,
      passwordHash: map['password_hash'] as String,
      fullName: map['full_name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      lastLogin: map['last_login'] != null
          ? DateTime.parse(map['last_login'] as String)
          : null,
    );
  }

  // Create a copy of User with updated fields
  User copyWith({
    int? id,
    String? email,
    String? passwordHash,
    String? fullName,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      fullName: fullName ?? this.fullName,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, fullName: $fullName, createdAt: $createdAt}';
  }
}
