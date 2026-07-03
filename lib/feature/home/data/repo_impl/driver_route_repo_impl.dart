
import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/core/utils/failure/server_failure.dart';
import 'package:fleet_driver/core/utils/network_info.dart';
import 'package:fleet_driver/feature/home/data/data_source/driver_route_data_source.dart';
import 'package:fleet_driver/feature/home/data/data_source/driver_route_local_data_source.dart';
import 'package:fleet_driver/feature/home/domain/entity/driver_route_entity.dart';
import 'package:fleet_driver/feature/home/domain/repo/driver_route_repo.dart';

class DriverRouteRepositoryImpl implements DriverRouteRepository {
  final DriverRouteDataSource remoteDataSource;
  final DriverRouteLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DriverRouteRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, List<DriverRouteEntity>>> getDriverRoutes(
      String driverId) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final routes = await remoteDataSource.getDriverRoutes(driverId);
        await localDataSource.cacheRoutes(routes);
        return Right(routes);
      } on CustomException catch (e) {
        return _fallbackToCache(driverId, e.message);
      } catch (e) {
        return _fallbackToCache(driverId, e.toString());
      }
    } else {
      return _fallbackToCache(driverId, 'No internet connection');
    }
  }

  Future<Either<Failure, List<DriverRouteEntity>>> _fallbackToCache(
      String driverId, String errorIfEmpty) async {
    final cached = await localDataSource.getCachedRoutes(driverId);
    if (cached.isNotEmpty) {
      return Right(cached);
    }
    return Left(Failure(errorIfEmpty));
  }
}