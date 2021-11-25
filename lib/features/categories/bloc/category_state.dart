part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  final List<CategoryModel> likedCategoryList;
  final List<CategoryModel> otherCategoryList;

  const CategoryLoadSuccess(
      {required this.likedCategoryList, required this.otherCategoryList});

  @override
  // TODO: implement props
  List<Object> get props => [likedCategoryList, otherCategoryList];
}

class CategoryLoadFailure extends CategoryState {}
