part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryEvent extends CategoryEvent {}

class GetNewsByCategory extends CategoryEvent {
  final String category;

  const GetNewsByCategory({required this.category});
}

class AddCategoryToInterestsEvent extends CategoryEvent {
  final List<CategoryModel> categoryListToBeAdded;
  final UserModel currentIser;

  const AddCategoryToInterestsEvent(
      {required this.categoryListToBeAdded, required this.currentIser});
}
