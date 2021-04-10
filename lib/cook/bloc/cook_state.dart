part of 'cook_bloc.dart';

enum CookStatus { loading, loaded, unknown, error }

class CookState extends Equatable {
  const CookState._({
    this.cook = Cook.empty,
    this.status = CookStatus.unknown,
  }) : assert(cook != null);

  const CookState.loading() : this._(status: CookStatus.loading);

  const CookState.loaded(Cook cook)
      : this._(status: CookStatus.loaded, cook: cook);

  const CookState.unknown() : this._();

  const CookState.error() : this._(status: CookStatus.error);

  final Cook cook;

  final CookStatus status;

  @override
  List<Object> get props => [cook, status];
}
