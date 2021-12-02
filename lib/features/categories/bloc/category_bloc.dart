import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/categories/models/category_model.dart';
import 'package:news_app/features/categories/services/category_service.dart';
import 'package:news_app/features/news_feed/model/comment_model.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';
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
    on<LikeNewsCategoryEvent>(_handleLikeNewsByCategoryEvent);
    on<UnlikeNewsCategoryEvent>(_handleUnLikeNewsByCategory);
    on<AddCommentCategoryEvent>(_handleCommentNewsByCategory);
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

  _handleLikeNewsByCategoryEvent(
      LikeNewsCategoryEvent event, Emitter<CategoryState> emit) async {
    final currentState = (state as CategoryLoadSuccess);

    try {
      await newsService.updateLike(event.likedNews.id!);
      final updatedOtherCatgoryList =
          List<CategoryModel>.from(currentState.otherCategoryList)
              .map((e) => e.categoryName == event.category.categoryName
                  ? event.category.copyWith(
                      news: e.news
                          .map((e) =>
                              e.id == event.likedNews.id ? event.likedNews : e)
                          .toList())
                  : e)
              .toList();
      final updatedLikedCatgoryList =
          List<CategoryModel>.from(currentState.likedCategoryList)
              .map((e) => e.categoryName == event.category.categoryName
                  ? event.category.copyWith(
                      news: e.news
                          .map((e) =>
                              e.id == event.likedNews.id ? event.likedNews : e)
                          .toList())
                  : e)
              .toList();

      emit(CategoryLoadSuccess(
          likedCategoryList: updatedLikedCatgoryList,
          otherCategoryList: updatedOtherCatgoryList));
    } catch (e, stk) {
      log(e.toString(), stackTrace: stk);
      emit(CategoryLoadFailure());
    }
  }

  _handleUnLikeNewsByCategory(
      UnlikeNewsCategoryEvent event, Emitter<CategoryState> emit) async {
    final currentState = (state as CategoryLoadSuccess);

    try {
      await newsService.updateLike(event.unlikedNews.id!);
      final updatedOtherCatgoryList =
          List<CategoryModel>.from(currentState.otherCategoryList)
              .map((e) => e.categoryName == event.category.categoryName
                  ? event.category.copyWith(
                      news: e.news
                          .map((el) => el.id == event.unlikedNews.id
                              ? event.unlikedNews
                              : el)
                          .toList())
                  : e)
              .toList();
      final updatedLikedCatgoryList =
          List<CategoryModel>.from(currentState.likedCategoryList)
              .map((e) => e.categoryName == event.category.categoryName
                  ? event.category.copyWith(
                      news: e.news
                          .map((e) => e.id == event.unlikedNews.id
                              ? event.unlikedNews
                              : e)
                          .toList())
                  : e)
              .toList();

      emit(CategoryLoadSuccess(
          likedCategoryList: updatedLikedCatgoryList,
          otherCategoryList: updatedOtherCatgoryList));
    } catch (e, stk) {
      log(e.toString(), stackTrace: stk);
      emit(CategoryLoadFailure());
    }
  }

  _handleCommentNewsByCategory(
      AddCommentCategoryEvent event, Emitter<CategoryState> emit) async {
    final currentState = (state as CategoryLoadSuccess);

    try {
      await newsService.updateLike(event.news.id!);
      final updatedOtherCatgoryList =
          List<CategoryModel>.from(currentState.otherCategoryList)
              .map((e) => e.categoryName == event.category.categoryName
                  ? event.category.copyWith(
                      news: event.category.news
                          .map((e) => e.id == event.news.id ? event.news : e)
                          .toList())
                  : e)
              .toList();
      final updatedLikedCatgoryList =
          List<CategoryModel>.from(currentState.likedCategoryList)
              .map((e) => e.categoryName == event.category.categoryName
                  ? event.category.copyWith(
                      news: event.category.news
                          .map((e) => e.id == event.news.id ? event.news : e)
                          .toList())
                  : e)
              .toList();

      emit(CategoryLoadSuccess(
          likedCategoryList: updatedLikedCatgoryList,
          otherCategoryList: updatedOtherCatgoryList));
    } catch (e, stk) {
      log(e.toString(), stackTrace: stk);
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
