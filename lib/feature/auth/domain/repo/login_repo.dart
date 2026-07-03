 import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/feature/auth/domain/entity/login_entity.dart';


abstract class LogInRepo{
  Future<Either<Failure,LogInEntity>>logIn({ required String email, required String password});
 }