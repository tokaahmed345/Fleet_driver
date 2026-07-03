import 'package:fleet_driver/core/utils/service/api_service.dart';
import 'package:fleet_driver/core/utils/service/endpoints.dart';
import '../models/free_seats_log_model.dart';

class LogFreeSeatsRemoteDataSource {
  final ApiService apiService;

  LogFreeSeatsRemoteDataSource(this.apiService);

  Future<void> submitLog(FreeSeatsLogModel log) async {
    await apiService.post(
      EndPoints.logs,
      data: {
        'stationId': log.stationId,
        'routeId': log.routeId,
        'freeSeats': log.freeSeats,
      },
    );
  }
}