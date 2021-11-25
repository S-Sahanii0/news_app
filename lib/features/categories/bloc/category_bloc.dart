import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/categories/models/category_model.dart';
import 'package:news_app/features/categories/services/category_service.dart';
import 'package:news_app/features/news_feed/services/news_service.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService catgoryService;
  final NewsService newsService;

  CategoryBloc({
    required this.catgoryService,
    required this.newsService,
  }) : super(CategoryInitial()) {
    on<GetCategoryEvent>(_handleGetCategoryEvent);
    on<GetNewsByCategory>(_handleGetNewsByCategory);
    on<LikeCategoryEvent>(_handleLikeCatgoryEvent);
  }

  _handleGetCategoryEvent(
      GetCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      print("eta pugyo");
      emit(CategoryLoading());
      final result = await catgoryService.getCategoryList();
      final likedCategory = <CategoryModel>[];
      event.user!.chosenCategories!.forEach((categoryName) {
        likedCategory.addAll(result
            .where((element) => element.categoryName == categoryName)
            .toList());
        result.remove(likedCategory.last);
      });
      emit(CategoryLoadSuccess(
          likedCategoryList: likedCategory, otherCategoryList: result));
    } catch (e) {
      emit(CategoryLoadFailure());
    }
  }

  _handleLikeCatgoryEvent(
      LikeCategoryEvent event, Emitter<CategoryState> emit) async {
    var currentState = state as CategoryLoadSuccess;
    try {
      print("eta pugyo");
      emit(CategoryLoading());
      final result = await catgoryService.getCategoryList();
      final likedCategory =
          List<CategoryModel>.from(currentState.likedCategoryList)
            ..add(event.caytegory);
      result.remove(event.caytegory);

      emit(CategoryLoadSuccess(
          likedCategoryList: likedCategory, otherCategoryList: result));
    } catch (e) {
      emit(CategoryLoadFailure());
    }
  }

  _handleGetNewsByCategory(
      GetNewsByCategory event, Emitter<CategoryState> emit) async {
    var currentState = state as CategoryLoadSuccess;
    try {
      emit(CategoryLoading());
      final news =
          await newsService.getNewsByCategory(event.category.categoryName);

      final updatedOtherCatgoryList =
          List<CategoryModel>.from(currentState.otherCategoryList)
              .map((e) => e.categoryName == event.category.categoryName
                  ? event.category.copyWith(news: news)
                  : e)
              .toList();
      final updatedLikedCatgoryList =
          List<CategoryModel>.from(currentState.likedCategoryList)
              .map((e) => e.categoryName == event.category.categoryName
                  ? event.category.copyWith(news: news)
                  : e)
              .toList();
      emit(CategoryLoadSuccess(
          likedCategoryList: updatedLikedCatgoryList,
          otherCategoryList: updatedOtherCatgoryList));
    } catch (e) {
      emit(CategoryLoadFailure());
    }
  }
}
