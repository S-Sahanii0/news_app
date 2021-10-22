import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_app/features/auth/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<UserModel> registerUser(UserModel user) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email, password: user.password!);
    users.doc(result.user!.uid).set({
      "id": result.user!.uid,
      "username": user.username,
      "email": user.email,
    });
    final userModel = await users.doc(result.user!.uid).get();

    final newUser = <String, dynamic>{};
    newUser["id"] = result.user!.uid;
    newUser["email"] = userModel.get("email");
    newUser["username"] = userModel.get("username");

    return UserModel.fromMap(newUser);
  }

  Stream<User?> checkUser() {
    return _firebaseAuth.authStateChanges().asBroadcastStream();
  }

  void logout() async {
    await _firebaseAuth.signOut();
  }

  Future login(UserModel userModel) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: userModel.email, password: userModel.password!);
  }
}
