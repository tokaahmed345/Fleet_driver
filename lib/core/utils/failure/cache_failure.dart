import 'package:fleet_driver/core/utils/failure/failure.dart';

class CacheFailure extends Failure {
  CacheFailure(super.message);

  factory CacheFailure.fromException(Object e) {
    return CacheFailure('Error happened: ${e.toString()}');
  }
}