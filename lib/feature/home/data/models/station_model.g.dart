// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StationModelAdapter extends TypeAdapter<StationModel> {
  @override
  final int typeId = 1;

  @override
  StationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StationModel(
      hiveId: fields[0] as String,
      hiveName: fields[1] as String,
      hiveLat: fields[2] as double,
      hiveLng: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, StationModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.hiveId)
      ..writeByte(1)
      ..write(obj.hiveName)
      ..writeByte(2)
      ..write(obj.hiveLat)
      ..writeByte(3)
      ..write(obj.hiveLng);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
