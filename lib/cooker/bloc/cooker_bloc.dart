import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'cooker_event.dart';
part 'cooker_state.dart';

class CookerBloc extends Bloc<CookerEvent, CookerState> {
  CookerBloc({
    @required CookersRepository cookersRepository,
    @required AuthenticationBloc authenticationBloc,
  })  : assert(cookersRepository != null),
        assert(authenticationBloc != null),
        _cookersRepository = cookersRepository,
        _authenticationBloc = authenticationBloc,
        super(const CookerState.unknown()) {
    _authSubscription = _authenticationBloc.listen((state) {
      _cookerSubscription?.cancel();

      if (state.status == AuthenticationStatus.authenticated) {
        _cookerSubscription =
            _cookersRepository.cooker(state.user.id).listen((cooker) {
          add(CookerLoadedEvent(cooker));
        });
      } else {
        add(const CookerLoadedEvent(Cooker.empty));
      }
    });
  }

  final AuthenticationBloc _authenticationBloc;
  final CookersRepository _cookersRepository;

  StreamSubscription _authSubscription;
  StreamSubscription<Cooker> _cookerSubscription;

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _cookerSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<CookerState> mapEventToState(CookerEvent event) async* {
    if (event is CookerUpdatedEvent) {
      yield* _mapCookerUpdatedEventToState(event);
    } else if (event is CookerCreatedEvent) {
      yield* _mapCookerCreatedEventToState(event);
    } else if (event is CookerLoadedEvent) {
      yield* _mapCookerLoadedEventToState(event);
    }
  }

  Stream<CookerState> _mapCookerLoadedEventToState(
    CookerLoadedEvent event,
  ) async* {
    yield CookerState.loaded(event.cooker);
  }

  Stream<CookerState> _mapCookerUpdatedEventToState(
    CookerUpdatedEvent event,
  ) async* {
    await _cookersRepository.update(event.cooker);
  }

  Stream<CookerState> _mapCookerCreatedEventToState(
    CookerCreatedEvent event,
  ) async* {
    final user = _authenticationBloc.state.user;

    assert(user.isNotEmpty);

    await _cookersRepository.create(event.cooker.copyWith(
      id: user.id,
      phoneNumber: user.phoneNumber,
    ));
  }
}
