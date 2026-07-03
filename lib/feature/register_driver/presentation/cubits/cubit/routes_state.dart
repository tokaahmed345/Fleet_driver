part of 'routes_cubit.dart';

sealed  class RoutesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RoutesInitial extends RoutesState {}

class RoutesLoading extends RoutesState {}

class RoutesSuccess extends RoutesState {
  final List<RouteEntity> routes;

  RoutesSuccess(this.routes);

  @override
  List<Object?> get props => [routes];
}

class RoutesFailure extends RoutesState {
  final String message;

  RoutesFailure(this.message);

  @override
  List<Object?> get props => [message];
}