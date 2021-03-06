import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthenticationUserChangedEvent(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;

  StreamSubscription<User> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChangedEvent) {
      await FirebaseAnalytics().setUserId(event.user.id);
      yield _mapAuthenticationUserChangedEventToState(event);
    } else if (event is AuthenticationLogoutRequestedEvent) {
      unawaited(_authenticationRepository.logOut());
    }
  }

  AuthenticationState _mapAuthenticationUserChangedEventToState(
    AuthenticationUserChangedEvent event,
  ) {
    return event.user.isNotEmpty
        ? AuthenticationState.authenticated(event.user)
        : const AuthenticationState.unauthenticated();
  }
}
