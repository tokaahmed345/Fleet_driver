// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_route_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DriverRouteModelAdapter extends TypeAdapter<DriverRouteModel> {
  @override
  final int typeId = 2;

  @override
  DriverRouteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DriverRouteModel(
      hiveId: fields[0] as String,
      hiveDriverId: fields[1] as String,
      hiveName: fields[2] as String,
      hiveStations: (fields[3] as List).cast<StationModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, DriverRouteModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.hiveId)
      ..writeByte(1)
      ..write(obj.hiveDriverId)
      ..writeByte(2)
      ..write(obj.hiveName)
      ..writeByte(3)
      ..write(obj.hiveStations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverRouteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
