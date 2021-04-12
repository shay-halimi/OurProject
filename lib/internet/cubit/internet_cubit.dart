import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  InternetCubit() : super(const InternetState.unknown()) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_handleResult);
  }

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  Future<void> check() async {
    emit(const InternetState.loading());

    try {
      await _connectivity.checkConnectivity().then(_handleResult);
    } on PlatformException {
      emit(const InternetState.unknown());
    }
  }

  Future<void> _handleResult(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      emit(const InternetState.error());
    } else {
      try {
        /// @TODO(Matan) Connectivity package has a bug
        /// @TODO(Matan) Find better way to check connection

        final result = await InternetAddress.lookup('google.com');

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          emit(const InternetState.loaded());
        } else {
          emit(const InternetState.error());
        }
      } on IOException {
        emit(const InternetState.error());
      }
    }
  }
}
