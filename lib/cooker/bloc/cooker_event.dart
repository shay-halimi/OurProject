part of 'cooker_bloc.dart';

abstract class CookerEvent extends Equatable {
  const CookerEvent();

  @override
  List<Object> get props => [];
}

class CookerLoadedEvent extends CookerEvent {
  const CookerLoadedEvent(this.cooker);

  final Cooker cooker;

  @override
  List<Object> get props => [cooker];
}

class CookerCreatedEvent extends CookerEvent {
  const CookerCreatedEvent(this.cooker);

  final Cooker cooker;

  @override
  List<Object> get props => [cooker];
}

class CookerUpdatedEvent extends CookerEvent {
  const CookerUpdatedEvent(this.cooker);

  final Cooker cooker;

  @override
  List<Object> get props => [cooker];
}
