import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';
import '../models/user_model.dart';
import '../../news_feed/services/news_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final NewsService newsService;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  AuthService({required this.newsService});

  Future<Stream<Future<UserModel>>> registerUser(UserModel user) async {
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
    return getCurrentUser(result.user!.uid);
  }

  Stream<User?> checkUser() {
    return _firebaseAuth.authStateChanges().asBroadcastStream();
  }

  Stream<Future<UserModel>> getCurrentUser(String uid) {
    return users.doc(uid).snapshots().map((event) async {
      final userModel = event.data() as Map<String, dynamic>;

      final newUser = <String, dynamic>{};

      newUser["id"] = uid;
      newUser["email"] = userModel["email"];
      newUser["username"] = userModel["username"];
      newUser["bookmarks"] = (await newsService.getNewsModel(
          (userModel["bookmark"] as List<dynamic>)
              .map((e) => e.toString())
              .toList()));
      newUser["chosenCategories"] = userModel["chosenCategory"];
      newUser["history"] = await newsService.getNewsModel(
          (userModel["history"] as List<dynamic>)
              .map((e) => e.toString())
              .toList());

      return UserModel.fromMap(newUser);
    });
  }

  void logout() async {
    await _firebaseAuth.signOut();
  }

  Future<Stream<Future<UserModel>>> login(UserModel userModel) async {
    print(await _firebaseAuth.signInWithEmailAndPassword(
        email: userModel.email, password: userModel.password!));
    final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: userModel.email, password: userModel.password!);
    return getCurrentUser(result.user!.uid);
  }
}
