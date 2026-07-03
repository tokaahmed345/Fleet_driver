// feature/auth/data/repo/login_repo_impl.dart
import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/core/utils/failure/server_failure.dart';
import 'package:fleet_driver/feature/auth/data/data_source/login_remote_data_source.dart';
import 'package:fleet_driver/feature/auth/domain/entity/login_entity.dart';
import 'package:fleet_driver/feature/auth/domain/repo/login_repo.dart';

class LogInRepoImpl implements LogInRepo {
  final LogInRemoteDataSource remoteDataSource;
  LogInRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LogInEntity>> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.logIn(
        email: email,
        password: password,
      );
      return Right(result);
    } on CustomException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}