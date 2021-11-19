import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_model.dart';
import '../../news_feed/services/news_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _newsService = NewsService();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<UserModel> registerUser(UserModel user) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email, password: user.password!);
    users.doc(result.user!.uid).set({
      "id": result.user!.uid,
      "username": user.username,
      "email": user.email,
      "bookmark": [],
      "chosenCategory": [],
      "history": [],
    });
    final userModel = await users.doc(result.user!.uid).get();

    final newUser = <String, dynamic>{};
    newUser["id"] = result.user!.uid;
    newUser["email"] = userModel.get("email");
    newUser["username"] = userModel.get("username");
    newUser["bookmarks"] = userModel.get("bookmark");
    newUser["chosenCategories"] = userModel.get("chosenCategory");
    newUser["history"] = userModel.get("history");

    return UserModel.fromMap(newUser);
  }

  Stream<User?> checkUser() {
    print("checking");
    return _firebaseAuth.authStateChanges().asBroadcastStream();
  }

  Future<UserModel> getCurrentUser(String uid) async {
    final userModel = await users.doc(uid).get();

    print(userModel);
    final newUser = <String, dynamic>{};
    print(userModel.get("bookmark"));
    newUser["id"] = uid;
    newUser["email"] = userModel.get("email");
    newUser["username"] = userModel.get("username");
    newUser["bookmarks"] = await _newsService.getNewsModel(
        (userModel.get("bookmark") as List<dynamic>)
            .map((e) => e.toString())
            .toList());
    newUser["chosenCategories"] = userModel.get("chosenCategory");
    newUser["history"] = await _newsService.getNewsModel(
        (userModel.get("history") as List<dynamic>)
            .map((e) => e.toString())
            .toList());

    return UserModel.fromMap(newUser);
  }

  void logout() async {
    await _firebaseAuth.signOut();
  }

  Future login(UserModel userModel) async {
    print(await _firebaseAuth.signInWithEmailAndPassword(
        email: userModel.email, password: userModel.password!));
    final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: userModel.email, password: userModel.password!);
    return getCurrentUser(result.user!.uid);
  }
}
