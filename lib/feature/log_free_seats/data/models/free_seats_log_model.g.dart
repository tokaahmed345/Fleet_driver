// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_seats_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FreeSeatsLogModelAdapter extends TypeAdapter<FreeSeatsLogModel> {
  @override
  final int typeId = 3;

  @override
  FreeSeatsLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FreeSeatsLogModel(
      stationId: fields[0] as String,
      stationName: fields[1] as String,
      routeId: fields[2] as String,
      freeSeats: fields[3] as int,
      timestamp: fields[4] as String,
      synced: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FreeSeatsLogModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.stationId)
      ..writeByte(1)
      ..write(obj.stationName)
      ..writeByte(2)
      ..write(obj.routeId)
      ..writeByte(3)
      ..write(obj.freeSeats)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FreeSeatsLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
