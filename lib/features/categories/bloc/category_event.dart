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

class AddCategoryToInterestsEvent extends CategoryEvent {
  final List<CategoryModel> categoryListToBeAdded;
  final UserModel currentIser;

  const AddCategoryToInterestsEvent(
      {required this.categoryListToBeAdded, required this.currentIser});
}
