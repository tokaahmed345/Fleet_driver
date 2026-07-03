import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/feature/home/domain/entity/driver_route_entity.dart';
import 'package:fleet_driver/feature/home/domain/repo/driver_route_repo.dart';


class GetDriverRoutesUseCase {
  final DriverRouteRepository repository;

  GetDriverRoutesUseCase(this.repository);

  Future<Either<Failure, List<DriverRouteEntity>>> call(String driverId) {
    return repository.getDriverRoutes(driverId);
  }
}