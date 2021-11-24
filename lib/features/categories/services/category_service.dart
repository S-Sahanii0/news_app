import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/features/categories/models/category_model.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';
import 'package:news_app/features/news_feed/services/news_service.dart';

class CategoryService {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference categoryRef =
      FirebaseFirestore.instance.collection('category');
  CollectionReference newsRef = FirebaseFirestore.instance.collection('news');

  Future<List<CategoryModel>> getCategoryList() async {
    final categoryList = <CategoryModel>[];
    (await categoryRef.get()).docs.forEach((e) async {
      var categoryData = e.data() as Map<String, dynamic>;

      categoryList.add(CategoryModel.fromMap(
          {"categoryName": categoryData['name'], "news": []}));
    });

    return categoryList;
  }
}
