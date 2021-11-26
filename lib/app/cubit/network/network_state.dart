part of 'network_cubit.dart';

abstract class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object> get props => [];
}

class NetworkInitial extends NetworkState {}

class GoodNetwork extends NetworkState {}

class BadNetwork extends NetworkState {}
