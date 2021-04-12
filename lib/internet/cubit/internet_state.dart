part of 'internet_cubit.dart';

enum InternetStatus { loading, loaded, unknown, error }

class InternetState extends Equatable {
  const InternetState._({
    this.status = InternetStatus.unknown,
  });

  const InternetState.loading() : this._(status: InternetStatus.loading);

  const InternetState.loaded() : this._(status: InternetStatus.loaded);

  const InternetState.unknown() : this._(status: InternetStatus.unknown);

  const InternetState.error() : this._(status: InternetStatus.error);

  final InternetStatus status;

  @override
  List<Object> get props => [status];
}
