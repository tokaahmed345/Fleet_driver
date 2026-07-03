
import 'package:hive/hive.dart';
import 'package:fleet_driver/feature/home/domain/entity/station_entity.dart';

part 'station_model.g.dart';

@HiveType(typeId: 1)
class StationModel extends StationEntity {
  @HiveField(0) final String hiveId;
  @HiveField(1) final String hiveName;
  @HiveField(2) final double hiveLat;
  @HiveField(3) final double hiveLng;

  const StationModel({
    required this.hiveId,
    required this.hiveName,
    required this.hiveLat,
    required this.hiveLng,
  }) : super(id: hiveId, name: hiveName, lat: hiveLat, lng: hiveLng);

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      hiveId: json['id'],
      hiveName: json['name'],
      hiveLat: (json['lat'] as num).toDouble(),
      hiveLng: (json['lng'] as num).toDouble(),
    );
  }
}