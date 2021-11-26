part of 'navigation_cubit.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class MyFeedState extends NavigationState {}

class DiscoverState extends NavigationState {}

class CategoryState extends NavigationState {}

class ChannelsState extends NavigationState {}

class ProfileState extends NavigationState {}
