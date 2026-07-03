import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/feature/home/domain/entity/driver_route_entity.dart';

abstract class DriverRouteRepository {
  Future<Either<Failure, List<DriverRouteEntity>>> getDriverRoutes(String driverId);
}