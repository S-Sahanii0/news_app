part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryEvent extends CategoryEvent {
  final UserModel? user;

  GetCategoryEvent({this.user});
}

class GetNewsByCategory extends CategoryEvent {
  final CategoryModel category;

  const GetNewsByCategory({required this.category});
}

class LikeCategoryEvent extends CategoryEvent {
  final CategoryModel caytegory;

  const LikeCategoryEvent({required this.caytegory});
}

class UnlikeCategoryEvent extends CategoryEvent {
  final CategoryModel caytegory;

  const UnlikeCategoryEvent({required this.caytegory});
}

class AddCategoryToInterestsEvent extends CategoryEvent {
  final List<CategoryModel> categoryListToBeAdded;
  final UserModel currentIser;

  const AddCategoryToInterestsEvent(
      {required this.categoryListToBeAdded, required this.currentIser});
}

class LikeNewsCategoryEvent extends CategoryEvent {
  final News likedNews;
  final CategoryModel category;

  const LikeNewsCategoryEvent({
    required this.likedNews,
    required this.category,
  });
}

class UnlikeNewsCategoryEvent extends CategoryEvent {
  final News unlikedNews;
  final CategoryModel category;

  const UnlikeNewsCategoryEvent({
    required this.category,
    required this.unlikedNews,
  });
}

class AddCommentCategoryEvent extends CategoryEvent {
  final CommentModel comment;
  final News news;
  final CategoryModel category;

  const AddCommentCategoryEvent({
    required this.comment,
    required this.news,
    required this.category,
  });
}
