import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/feature/auth/domain/entity/login_entity.dart';

import 'package:fleet_driver/feature/auth/domain/repo/login_repo.dart';

class LogInUseCase {
final LogInRepo repo;

  LogInUseCase({required this.repo});

  Future<Either<Failure,LogInEntity>>call({ required String email, required String password,})async{
 return await repo.logIn( email: email,password: password );

  }

}