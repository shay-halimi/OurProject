import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'cook_widget_state.dart';

class CookWidgetCubit extends Cubit<CookWidgetState> {
  CookWidgetCubit({
    @required CooksRepository cooksRepository,
  })  : assert(cooksRepository != null),
        _cooksRepository = cooksRepository,
        super(CookWidgetInitial());

  final CooksRepository _cooksRepository;
  StreamSubscription _cookSubscription;

  Future<void> load(String cookId) async {
    emit(CookWidgetLoading(cookId));

    await _cookSubscription?.cancel();

    _cookSubscription = _cooksRepository.cook(cookId).listen((event) {
      emit(CookWidgetLoaded(event));
    });
  }

  @override
  Future<void> close() {
    _cookSubscription?.cancel();
    return super.close();
  }
}
