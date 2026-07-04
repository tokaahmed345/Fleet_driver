import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fleet_driver/core/utils/constant/app_constant.dart';
import 'package:fleet_driver/core/utils/service/location_service.dart';
import 'package:fleet_driver/feature/home/domain/entity/driver_route_entity.dart';
import 'package:fleet_driver/feature/home/domain/usecase/driver_route_usecase.dart';
part 'driver_route_state.dart';
class DriverRouteCubit extends Cubit<DriverRouteState> {
  final GetDriverRoutesUseCase getDriverRoutesUseCase;
  final LocationService locationService;

  DriverRouteCubit(this.getDriverRoutesUseCase, this.locationService)
    : super(DriverRouteInitial());
  static const double geofenceRadius = AppConstants.geofenceRadiusMeters;

  Future<void> fetchDriverRoutes(String driverId) async {
    emit(DriverRouteLoading());

    final result = await getDriverRoutesUseCase.call(driverId);

    result.fold(
      (failure) => emit(DriverRouteFailure(errMessage: failure.message)),
      (routes) => emit(
        DriverRouteSuccess(
          routes: routes,
          currentStationIndex: 0,
          isNearStation: false,
        ),
      ),
    );
  }

  Future<void> checkDriverLocation() async {
    final currentState = state;
    if (currentState is! DriverRouteSuccess) return;
    if (currentState.routes.isEmpty) return;

    final position = await locationService.getCurrentLocation();
    if (position == null) {
      // print('⚠️ position is null');
      return;
    }

    final stations = currentState.routes.first.stations;

    int? nearestIndex;
    double? nearestDistance;

    for (int i = 0; i < stations.length; i++) {
      final distance = locationService.calculateDistance(
        lat1: position.latitude,
        lng1: position.longitude,
        lat2: stations[i].lat,
        lng2: stations[i].lng,
      );


      if (nearestDistance == null || distance < nearestDistance) {
        nearestDistance = distance;
        nearestIndex = i;
      }
    }

    final isNear = nearestDistance != null && nearestDistance <= geofenceRadius;

    emit(
      currentState.copyWith(
        currentStationIndex: isNear
            ? nearestIndex!
            : currentState.currentStationIndex,
        isNearStation: isNear,
      ),
    );
  }
}
