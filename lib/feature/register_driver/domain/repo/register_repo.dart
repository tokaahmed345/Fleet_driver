import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/feature/register_driver/domain/entity/register_driver_entity.dart';

abstract class RegisterDriverRepo {
  Future<Either<Failure, RegisterDriverEntity>> registerDriver({
    required String name,
    required String email,
    required String password,
    required String route,
  });
}