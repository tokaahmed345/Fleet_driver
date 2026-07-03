import 'package:fleet_driver/feature/register_driver/domain/entity/route_entity.dart';

class RouteModel extends RouteEntity {
  RouteModel({
    required super.id,
    required super.name,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'],
      name: json['name'],
    );
  }
}