import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cooks_repository/cooks_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'cook_event.dart';
part 'cook_state.dart';

class CookBloc extends Bloc<CookEvent, CookState> {
  CookBloc({
    @required CooksRepository cooksRepository,
    @required AuthenticationBloc authenticationBloc,
  })  : assert(cooksRepository != null),
        assert(authenticationBloc != null),
        _cooksRepository = cooksRepository,
        _authenticationBloc = authenticationBloc,
        super(const CookState.unknown()) {
    _authSubscription = _authenticationBloc.stream.listen((state) {
      _cookSubscription?.cancel();

      if (state.status == AuthenticationStatus.authenticated) {
        _cookSubscription = _cooksRepository.cook(state.user.id).listen((cook) {
          add(CookLoadedEvent(cook));
        });
      } else {
        add(const CookLoadedEvent(Cook.empty));
      }
    });
  }

  final AuthenticationBloc _authenticationBloc;

  final CooksRepository _cooksRepository;

  StreamSubscription _authSubscription;

  StreamSubscription<Cook> _cookSubscription;

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _cookSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<CookState> mapEventToState(CookEvent event) async* {
    if (event is CookUpdatedEvent) {
      yield* _mapCookUpdatedEventToState(event);
    } else if (event is CookCreatedEvent) {
      yield* _mapCookCreatedEventToState(event);
    } else if (event is CookLoadedEvent) {
      yield* _mapCookLoadedEventToState(event);
    }
  }

  Stream<CookState> _mapCookLoadedEventToState(
    CookLoadedEvent event,
  ) async* {
    if (event.cook.isEmpty) {
      yield const CookState.error();
    } else {
      yield CookState.loaded(event.cook);
    }
  }

  Stream<CookState> _mapCookUpdatedEventToState(
    CookUpdatedEvent event,
  ) async* {
    await _cooksRepository.update(event.cook);
  }

  Stream<CookState> _mapCookCreatedEventToState(
    CookCreatedEvent event,
  ) async* {
    final user = _authenticationBloc.state.user;

    assert(user.isNotEmpty);

    await _cooksRepository.create(event.cook.copyWith(
      id: user.id,
      phoneNumber: user.phoneNumber,
    ));
  }
}
