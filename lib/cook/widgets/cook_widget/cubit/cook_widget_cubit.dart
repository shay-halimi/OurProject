import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'cook_widget_state.dart';

class CookWidgetCubit extends Cubit<CookWidgetState> {
  CookWidgetCubit({
    @required CooksRepository cooksRepository,
    @required String cookId,
  })  : assert(cooksRepository != null),
        assert(cookId != null),
        _cooksRepository = cooksRepository,
        super(CookWidgetInitial()) {
    _cookSubscription = _cooksRepository.cook(cookId).listen((event) {
      emit(CookWidgetLoaded(event));
    });
  }

  final CooksRepository _cooksRepository;

  StreamSubscription _cookSubscription;

  @override
  Future<void> close() {
    _cookSubscription?.cancel();
    return super.close();
  }
}
