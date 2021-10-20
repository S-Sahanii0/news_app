import 'dart:convert';

class UserModel {
  final String? id;
  final String email;
  final String username;
  final String? password;
  UserModel({
    this.id,
    required this.email,
    required this.username,
    this.password,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? "",
      email: map['email'] as String? ?? "",
      username: map['username'] as String? ?? "",
      password: map['password'] as String? ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ username.hashCode ^ password.hashCode;
  }
}
