import 'station_entity.dart';

class DriverRouteEntity {
  final String id;
  final String driverId;
  final String name;
  final List<StationEntity> stations;

  const DriverRouteEntity({
    required this.id,
    required this.driverId,
    required this.name,
    required this.stations,
  });
}