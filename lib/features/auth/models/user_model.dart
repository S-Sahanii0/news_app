import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:news_app/features/categories/models/category_model.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';

class UserModel {
  final String? id;
  final String email;
  final String username;
  final String? password;
  final List<String>? bookmarks;
  final List<String>? history;
  final List<String>? chosenCategories;
  UserModel({
    this.id,
    required this.email,
    required this.username,
    this.password,
    this.bookmarks,
    this.history,
    this.chosenCategories,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? password,
    List<String>? bookmarks,
    List<String>? history,
    List<String>? chosenCategories,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      bookmarks: bookmarks ?? this.bookmarks,
      history: history ?? this.history,
      chosenCategories: chosenCategories ?? this.chosenCategories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'bookmarks': bookmarks,
      'history': history,
      'chosenCategories': chosenCategories,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] : null,
      email: map['email'],
      username: map['username'],
      password: map['password'] != null ? map['password'] : null,
      bookmarks:
          map['bookmarks'] != null ? List<String>.from(map['bookmarks']) : null,
      history:
          map['history'] != null ? List<String>.from(map['history']) : null,
      chosenCategories: map['chosenCategories'] != null
          ? List<String>.from(map['chosenCategories'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, username: $username, password: $password, bookmarks: $bookmarks, history: $history, chosenCategories: $chosenCategories)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.username == username &&
        other.password == password &&
        listEquals(other.bookmarks, bookmarks) &&
        listEquals(other.history, history) &&
        listEquals(other.chosenCategories, chosenCategories);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        username.hashCode ^
        password.hashCode ^
        bookmarks.hashCode ^
        history.hashCode ^
        chosenCategories.hashCode;
  }
}
