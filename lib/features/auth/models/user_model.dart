import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../categories/models/category_model.dart';
import '../../news_feed/model/news_model.dart';

class UserModel {
  final String? id;
  final String email;
  final String? username;
  final String? password;
  final List<News>? bookmarks;
  final List<News>? history;
  final List<String>? chosenCategories;
  UserModel({
    this.id,
    required this.email,
    this.username,
    this.password,
    this.bookmarks,
    this.history,
    this.chosenCategories,
  });

  static UserModel empty = UserModel(email: '');

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? password,
    List<News>? bookmarks,
    List<News>? history,
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
      'bookmarks': bookmarks?.map((x) => x.toMap()).toList(),
      'history': history?.map((x) => x.toMap()).toList(),
      'chosenCategories': chosenCategories,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] : null,
      email: map['email'],
      username: map['username'] != null ? map['username'] : null,
      password: map['password'] != null ? map['password'] : null,
      bookmarks: map['bookmarks'] != null
          ? List<News>.from(map['bookmarks']?.map((x) => News.fromMap(x)))
          : null,
      history: map['history'] != null
          ? List<News>.from(map['history']?.map((x) => News.fromMap(x)))
          : null,
      chosenCategories: map['chosenCategories'] != null
          ? List<String>.from(map['chosenCategories'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

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
