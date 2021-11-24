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
  CategoryBloc({required this.catgoryService, required this.newsService})
      : super(CategoryInitial()) {
    on<GetCategoryEvent>(_handleGetCategoryEvent);
    on<GetNewsByCategory>(_handleGetNewsByCategory);
  }

  _handleGetCategoryEvent(
      GetCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      print("eta pugyo");
      final result = await catgoryService.getCategoryList();
      emit(CategoryLoadSuccess(
          likedCategoryList: const [], otherCategoryList: result));
    } catch (e) {
      emit(CategoryLoadFailure());
    }
  }

  _handleGetNewsByCategory(
      GetNewsByCategory event, Emitter<CategoryState> emit) async {
    try {
      print("eta pugyo");
      final categoryList = await catgoryService.getCategoryList();
      final news = await newsService.getNewsByCategory(event.category);

      emit(CategoryLoadSuccess(likedCategoryList: const [], otherCategoryList: [
        categoryList
            .where((element) => element.categoryName == event.category)
            .first
            .copyWith(news: news)
      ]));
    } catch (e) {
      emit(CategoryLoadFailure());
    }
  }
}
