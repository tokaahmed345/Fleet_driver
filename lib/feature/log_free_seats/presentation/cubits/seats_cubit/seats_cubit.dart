
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fleet_driver/core/utils/constant/app_constant.dart';
import 'package:fleet_driver/core/utils/service/location_service.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/entity/log_free_seats_entity.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/use_case/log_free_seats_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'seats_state.dart';

class SeatsCubit extends Cubit<SeatsState> {
  final LogFreeSeatsUseCase logFreeSeatsUseCase;
  final LocationService locationService;
static const double geofenceRadiusMeters = AppConstants.geofenceRadiusMeters;


  SeatsCubit({
    required this.logFreeSeatsUseCase,
    required this.locationService,
  }) : super(SeatsInitial());

  Future<bool> checkGeofence({
    required double stationLat,
    required double stationLng,
  }) async {
    if (isClosed) return false;
    emit(SeatsCheckingLocation());

    final position = await locationService.getCurrentLocation();

    if (isClosed) return false; 
    if (position == null) {
      emit(SeatsLocationError('Unable to determine your location right now'));
      return false;
    }

    final distance = locationService.calculateDistance(
      lat1: position.latitude,
      lng1: position.longitude,
      lat2: stationLat,
      lng2: stationLng,
    );


    if (isClosed) return false;
    if (distance <= geofenceRadiusMeters) {
      emit(SeatsWithinRange(distance));
      return true;
    } else {
      emit(SeatsOutOfRange(distance));
      return false;
    }
  }

  Future<void> submitFreeSeats({
    required String stationId,
    required String stationName,
    required String routeId,
    required int freeSeats,
  }) async {
    if (isClosed) return;
    emit(SeatsSubmitLoading());

    final log = FreeSeatsLogEntity(
      stationId: stationId,
      stationName: stationName,
      routeId: routeId,
      freeSeats: freeSeats,
      timestamp: DateTime.now(),
    );
    final result = await logFreeSeatsUseCase(log);

    if (isClosed) return; 
    result.fold(
      (failure) => emit(SeatsSubmitError(failure.message)),
      (synced) => emit(SeatsSubmitSuccess(synced)),
    );
  }
}