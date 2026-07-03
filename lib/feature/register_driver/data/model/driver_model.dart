import 'package:fleet_driver/feature/register_driver/domain/entity/register_driver_entity.dart';

class DriverModel extends RegisterDriverEntity {
  const DriverModel({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.route,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      route: json['route'] ?? '',
    );
  }
}