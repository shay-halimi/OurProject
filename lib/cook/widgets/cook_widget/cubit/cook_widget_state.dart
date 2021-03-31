part of 'cook_widget_cubit.dart';

@immutable
abstract class CookWidgetState extends Equatable {
  @override
  List<Object> get props => [];
}

class CookWidgetInitial extends CookWidgetState {}

class CookWidgetLoading extends CookWidgetState {
  CookWidgetLoading(this.cookId);

  final String cookId;

  @override
  List<Object> get props => [cookId];
}

class CookWidgetLoaded extends CookWidgetState {
  CookWidgetLoaded(this.cook);

  final Cook cook;

  @override
  List<Object> get props => [cook];
}
