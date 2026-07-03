
import 'package:hive/hive.dart';
import 'package:fleet_driver/feature/home/data/models/station_model.dart';
import 'package:fleet_driver/feature/home/domain/entity/driver_route_entity.dart';

part 'driver_route_model.g.dart';

@HiveType(typeId: 2)
class DriverRouteModel extends DriverRouteEntity {
  @HiveField(0) final String hiveId;
  @HiveField(1) final String hiveDriverId;
  @HiveField(2) final String hiveName;
  @HiveField(3) final List<StationModel> hiveStations;

  const DriverRouteModel({
    required this.hiveId,
    required this.hiveDriverId,
    required this.hiveName,
    required this.hiveStations,
  }) : super(id: hiveId, driverId: hiveDriverId, name: hiveName, stations: hiveStations);

  factory DriverRouteModel.fromJson(Map<String, dynamic> json) {
    return DriverRouteModel(
      hiveId: json['id'],
      hiveDriverId: json['driverId'],
      hiveName: json['name'],
      hiveStations: (json['stations'] as List)
          .map((s) => StationModel.fromJson(s))
          .toList(),
    );
  }
}
