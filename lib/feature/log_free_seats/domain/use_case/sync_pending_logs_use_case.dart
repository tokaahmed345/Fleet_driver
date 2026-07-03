import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/repo/log_free_seats_repo.dart';


class SyncPendingLogsUseCase {
  final LogFreeSeatsRepo repository;
  SyncPendingLogsUseCase(this.repository);

  Future<Either<Failure, void>> call() => repository.syncPendingLogs();
}