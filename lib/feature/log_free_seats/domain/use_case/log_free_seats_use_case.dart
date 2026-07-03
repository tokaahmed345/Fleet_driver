import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/entity/log_free_seats_entity.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/repo/log_free_seats_repo.dart';


class LogFreeSeatsUseCase {
  final LogFreeSeatsRepo repository;
  LogFreeSeatsUseCase(this.repository);

  Future<Either<Failure, bool>> call(FreeSeatsLogEntity log) {
    return repository.logFreeSeats(log);
  }
}