part of 'cook_widget_cubit.dart';

@immutable
abstract class CookWidgetState extends Equatable {
  @override
  List<Object> get props => [];
}

class CookWidgetInitial extends CookWidgetState {}

class CookWidgetLoaded extends CookWidgetState {
  CookWidgetLoaded(this.cook);

  final Cook cook;

  @override
  List<Object> get props => [cook];
}
