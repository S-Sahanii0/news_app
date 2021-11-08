import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:news_app/features/categories/models/category_model.dart';

class NewsService {
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  CollectionReference channel =
      FirebaseFirestore.instance.collection('channel');
  CollectionReference news = FirebaseFirestore.instance.collection('news');

  Future<void> addDataToFirebase() async {
    final String response =
        await rootBundle.loadString('assets/data/news_data.json');
    final data = await json.decode(response);
    List.from(data.keys).forEach((element) {
      category.add({"name": element, "news": data[element]});
    });
  }
}
