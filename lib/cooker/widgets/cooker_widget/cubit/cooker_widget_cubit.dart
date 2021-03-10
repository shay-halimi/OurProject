import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookers_repository/cookers_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'cooker_widget_state.dart';

class CookerWidgetCubit extends Cubit<CookerWidgetState> {
  CookerWidgetCubit({
    @required CookersRepository cookersRepository,
  })  : assert(cookersRepository != null),
        _cookersRepository = cookersRepository,
        super(CookerWidgetInitial());

  final CookersRepository _cookersRepository;
  StreamSubscription _cookerSubscription;

  Future<void> load(String cookerId) async {
    emit(CookerWidgetLoading(cookerId));

    await _cookerSubscription?.cancel();

    _cookerSubscription = _cookersRepository.cooker(cookerId).listen((event) {
      emit(CookerWidgetLoaded(event));
    });
  }

  @override
  Future<void> close() {
    _cookerSubscription?.cancel();
    return super.close();
  }
}
