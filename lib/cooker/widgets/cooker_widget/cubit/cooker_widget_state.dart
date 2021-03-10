part of 'cooker_widget_cubit.dart';

@immutable
abstract class CookerWidgetState extends Equatable {
  @override
  List<Object> get props => [];
}

class CookerWidgetInitial extends CookerWidgetState {}

class CookerWidgetLoading extends CookerWidgetState {
  CookerWidgetLoading(this.cookerId);

  final String cookerId;

  @override
  List<Object> get props => [cookerId];
}

class CookerWidgetLoaded extends CookerWidgetState {
  CookerWidgetLoaded(this.cooker);

  final Cooker cooker;

  @override
  List<Object> get props => [cooker];
}
