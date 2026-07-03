import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/core/utils/failure/server_failure.dart';
import 'package:fleet_driver/feature/register_driver/data/data_source/register_remot_data_source.dart';
import 'package:fleet_driver/feature/register_driver/domain/entity/register_driver_entity.dart';
import 'package:fleet_driver/feature/register_driver/domain/repo/register_repo.dart';


class RegisterDriverRepoImpl implements RegisterDriverRepo {
  final RegisterDriverRemoteDataSource remoteDataSource;

  RegisterDriverRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, RegisterDriverEntity>> registerDriver({
    required String name,
    required String email,
    required String password,
    required String route,
  }) async {
    try {
      final driver = await remoteDataSource.registerDriver(
        name: name,
        email: email,
        password: password,
        route: route,
      );
      return Right(driver);
    } on CustomException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}