import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/feature/register_driver/domain/entity/route_entity.dart';
import 'package:fleet_driver/feature/register_driver/domain/repo/route_repo.dart';

class GetAllRoutesUseCase {
  final RoutesRepo repo;

  GetAllRoutesUseCase(this.repo);

  Future<Either<Failure, List<RouteEntity>>> call() {
    return repo.getAllRoutes();
  }
}