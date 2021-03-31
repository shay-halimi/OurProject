part of 'cook_bloc.dart';

abstract class CookEvent extends Equatable {
  const CookEvent();

  @override
  List<Object> get props => [];
}

class CookLoadedEvent extends CookEvent {
  const CookLoadedEvent(this.cook);

  final Cook cook;

  @override
  List<Object> get props => [cook];
}

class CookCreatedEvent extends CookEvent {
  const CookCreatedEvent(this.cook);

  final Cook cook;

  @override
  List<Object> get props => [cook];
}

class CookUpdatedEvent extends CookEvent {
  const CookUpdatedEvent(this.cook);

  final Cook cook;

  @override
  List<Object> get props => [cook];
}
