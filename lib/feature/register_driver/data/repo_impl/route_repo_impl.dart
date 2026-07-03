import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/core/utils/failure/server_failure.dart';
import 'package:fleet_driver/feature/register_driver/data/data_source/route_remote_data_source.dart';
import 'package:fleet_driver/feature/register_driver/domain/entity/route_entity.dart';
import 'package:fleet_driver/feature/register_driver/domain/repo/route_repo.dart';

class RoutesRepoImpl implements RoutesRepo {
  final RoutesRemoteDataSource remoteDataSource;

  RoutesRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<RouteEntity>>> getAllRoutes() async {
    try {
      final routes = await remoteDataSource.getAllRoutes();
      return Right(routes);
    } on CustomException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}