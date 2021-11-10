// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  // CollectionReference channel =
  //     FirebaseFirestore.instance.collection('channel');
  // CollectionReference news = FirebaseFirestore.instance.collection('news');

  Future<void> addDataToFirebase() async {
    final String response =
        await rootBundle.loadString('assets/data/news_data.json');
    final data = await json.decode(response);
    List.from(data.keys).forEach((element) {
      category.doc(element).set({"name": element, "news": data[element]});
    });
  }

  test('Add to firebase', () async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAdvATQgl7JLfn8_a_fTSmao0Ns4M7jG8M",
          appId: "1:164727143815:web:92f193a617020d77de6722",
          messagingSenderId: "164727143815",
          projectId: "newsapp-c4509"),
    );
    await addDataToFirebase();
  });
}
