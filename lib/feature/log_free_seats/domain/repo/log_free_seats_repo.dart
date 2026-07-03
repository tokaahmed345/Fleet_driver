import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/entity/log_free_seats_entity.dart';


abstract class LogFreeSeatsRepo {
  Future<Either<Failure, bool>> logFreeSeats(FreeSeatsLogEntity log);

  Future<Either<Failure, List<FreeSeatsLogEntity>>> getPendingLogs();

  Future<Either<Failure, void>> syncPendingLogs();
}