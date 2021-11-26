import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit() : super(NetworkInitial()) {
    _connectionSubscription ??=
        Connectivity().onConnectivityChanged.listen((hasConnection) {
      if (hasConnection == ConnectivityResult.none) {
        emit(BadNetwork());
      } else {
        emit(GoodNetwork());
      }
    });
  }

  StreamSubscription? _connectionSubscription;

  @override
  Future<void> close() {
    _connectionSubscription?.cancel();
    return super.close();
  }
}
