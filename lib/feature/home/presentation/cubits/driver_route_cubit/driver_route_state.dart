part of 'driver_route_cubit.dart';

// sealed class DriverRouteState extends Equatable {
//   const DriverRouteState();

//   @override
//   List<Object> get props => [];
// }

// final class DriverRouteInitial extends DriverRouteState {}
// final class DriverRouteLoading extends DriverRouteState {}
// final class DriverRouteSuccess extends DriverRouteState {
//     final List<DriverRouteEntity> routes;

//   const DriverRouteSuccess({required this.routes});
//     @override
//   List<Object> get props => [routes];

// }
// final class DriverRouteFailure extends DriverRouteState {
//   final String errMessage;

//   const DriverRouteFailure({required this.errMessage});
// }


sealed class DriverRouteState extends Equatable {
  const DriverRouteState();

  @override
  List<Object> get props => [];
}

final class DriverRouteInitial extends DriverRouteState {}

final class DriverRouteLoading extends DriverRouteState {}

final class DriverRouteSuccess extends DriverRouteState {
  final List<DriverRouteEntity> routes;
  final int currentStationIndex;
  final bool isNearStation;

  const DriverRouteSuccess({
    required this.routes,
    required this.currentStationIndex,
    required this.isNearStation,
  });

  DriverRouteSuccess copyWith({
    List<DriverRouteEntity>? routes,
    int? currentStationIndex,
    bool? isNearStation,
  }) {
    return DriverRouteSuccess(
      routes: routes ?? this.routes,
      currentStationIndex: currentStationIndex ?? this.currentStationIndex,
      isNearStation: isNearStation ?? this.isNearStation,
    );
  }

  @override
  List<Object> get props => [routes, currentStationIndex, isNearStation];
}

final class DriverRouteFailure extends DriverRouteState {
  final String errMessage;

  const DriverRouteFailure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}