import 'package:fleet_driver/feature/log_free_seats/domain/entity/log_free_seats_entity.dart';
import 'package:hive/hive.dart';

part 'free_seats_log_model.g.dart';

@HiveType(typeId: 3) 
class FreeSeatsLogModel extends HiveObject {
  @HiveField(0)
  final String stationId;
  @HiveField(1)
  final String stationName;
  @HiveField(2)
  final String routeId;
  @HiveField(3)
  final int freeSeats;
  @HiveField(4)
  final String timestamp;
  @HiveField(5)
  bool synced;

  FreeSeatsLogModel({
    required this.stationId,
    required this.stationName,
    required this.routeId,
    required this.freeSeats,
    required this.timestamp,
    this.synced = false,
  });

  factory FreeSeatsLogModel.fromEntity(FreeSeatsLogEntity e) => FreeSeatsLogModel(
        stationId: e.stationId,
        stationName: e.stationName,
        routeId: e.routeId,
        freeSeats: e.freeSeats,
        timestamp: e.timestamp.toIso8601String(),
        synced: e.synced,
      );

  FreeSeatsLogEntity toEntity() => FreeSeatsLogEntity(
        stationId: stationId,
        stationName: stationName,
        routeId: routeId,
        freeSeats: freeSeats,
        timestamp: DateTime.parse(timestamp),
        synced: synced,
      );
}