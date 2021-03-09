part of 'cooker_bloc.dart';

enum CookerStatus { loading, loaded, unknown }

class CookerState extends Equatable {
  const CookerState._({
    this.status = CookerStatus.unknown,
    this.cooker = Cooker.empty,
  });

  const CookerState.loading() : this._(status: CookerStatus.loading);

  const CookerState.loaded(Cooker cooker)
      : this._(status: CookerStatus.loaded, cooker: cooker);

  const CookerState.unknown() : this._();

  final CookerStatus status;
  final Cooker cooker;

  @override
  List<Object> get props => [status, cooker];
}
