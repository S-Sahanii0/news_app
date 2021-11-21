import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(MyFeedState());

  void navigateToMyFeed() => emit(MyFeedState());

  void navigateToCategory() => emit(CategoryState());

  void navigateToChannels() => emit(ChannelsState());

  void navigateToProfile() => emit(ProfileState());
}
