import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fleet_driver/core/utils/failure/cache_failure.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/feature/log_free_seats/data/data_seource/log_free_seats_local_data_source.dart';
import 'package:fleet_driver/feature/log_free_seats/data/data_seource/log_free_seats_remote_data_source.dart';
import 'package:fleet_driver/feature/log_free_seats/data/models/free_seats_log_model.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/entity/log_free_seats_entity.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/repo/log_free_seats_repo.dart';

class SeatsRepositoryImpl implements LogFreeSeatsRepo {
  final LogFreeSeatsRemoteDataSource remote;
  final LogFreeSeatsLocalDataSource local;

  SeatsRepositoryImpl({required this.remote, required this.local});

 Future<bool> _hasConnection() async {
    final connectivityResult = await getIt.get<Connectivity>().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
  }


  @override
  Future<Either<Failure, bool>> logFreeSeats(FreeSeatsLogEntity log) async {
    final model = FreeSeatsLogModel.fromEntity(log);
    try {
      final hasNet = await _hasConnection();
      if (hasNet) {
        await remote.submitLog(model);
        return const Right(true); 
      } else {
        await local.cacheLog(model);
        return const Right(false);
      }
    } catch (e) {
      await local.cacheLog(model);
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, List<FreeSeatsLogEntity>>> getPendingLogs() async {
    try {
      final logs = await local.getUnsyncedLogs();
      return Right(logs.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncPendingLogs() async {
    try {
      final hasNet = await _hasConnection();
      if (!hasNet) return const Right(null);

      final unsynced = await local.getUnsyncedLogs();
      for (final log in unsynced) {
        await remote.submitLog(log);
        await local.markAsSynced(log);
      }
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}