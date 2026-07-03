import 'package:dartz/dartz.dart';
import 'package:fleet_driver/core/utils/failure/failure.dart';
import 'package:fleet_driver/feature/register_driver/domain/entity/register_driver_entity.dart';
import 'package:fleet_driver/feature/register_driver/domain/repo/register_repo.dart';

class RegisterDriverUseCase {
  final RegisterDriverRepo repo;

  RegisterDriverUseCase(this.repo);

  Future<Either<Failure, RegisterDriverEntity>> call({
    required String name,
    required String email,
    required String password,
    required String route,
  }) {
    return repo.registerDriver(
      name: name,
      email: email,
      password: password,
      route: route,
    );
  }
}