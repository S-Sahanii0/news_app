import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';
import '../models/user_model.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../news_feed/services/news_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<Stream<Future<UserModel>>> addToBookmarks(
      News newsToBookmark, String uid) async {
    final newsId = newsToBookmark.id!;
    await (users.doc(uid).update(
      {
        'bookmark': FieldValue.arrayUnion([newsId])
      },
    ));
    return getCurrentUser(uid);
  }

  Future<Stream<Future<UserModel>>> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final result = await _firebaseAuth.signInWithCredential(credential);

    users.doc(result.user!.uid).set({
      "id": result.user!.uid,
      "username": result.user!.displayName,
      "email": result.user!.email,
      "bookmark": [],
      "chosenCategory": [],
      "history": [],
    });
    // Once signed in, return the UserCredential
    return getCurrentUser(result.user!.uid);
  }

  // Future<Stream<Future<UserModel>>> signInWithFacebook() async {
  // Trigger the sign-in flow
  // final LoginResult loginResult = await FacebookAuth.instance.login();

  // // Create a credential from the access token
  // final OAuthCredential facebookAuthCredential =
  //     FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // // Once signed in, return the UserCredential
  // final result =
  //     await _firebaseAuth.signInWithCredential(facebookAuthCredential);

  // users.doc(result.user!.uid).set({
  //   "id": result.user!.uid,
  //   "username": result.user!.displayName,
  //   "email": result.user!.email,
  //   "bookmark": [],
  //   "chosenCategory": [],
  //   "history": [],
  // });
  // // Once signed in, return the UserCredential
  // return getCurrentUser(result.user!.uid);
  // }

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

  Future<Stream<Future<UserModel>>> removeFromBookmarks(
      News newsToBookmark, String uid) async {
    final newsId = newsToBookmark.id!;
    await (users.doc(uid).update(
      {
        'bookmark': FieldValue.arrayRemove([newsId])
      },
    ));
    return getCurrentUser(uid);
  }

  Future<Stream<Future<UserModel>>> addToHistory(
      News newsToAdd, String uid) async {
    final newsId = newsToAdd.id!;
    await users.doc(uid).update({
      'history': FieldValue.arrayUnion([newsId])
    });
    return getCurrentUser(uid);
  }

  Future<Stream<Future<UserModel>>> removeFromHistory(
      News newsToAdd, String uid) async {
    final newsId = newsToAdd.id!;
    await (users.doc(uid).update(
      {
        'history': FieldValue.arrayRemove([newsId])
      },
    ));
    return getCurrentUser(uid);
  }

  Future<Stream<Future<UserModel>>> addChosenCategory(
      List<String> categoryList, String uid) async {
    await (users.doc(uid).update(
      {'chosenCategory': FieldValue.arrayUnion(categoryList)},
    ));
    return getCurrentUser(uid);
  }
}
