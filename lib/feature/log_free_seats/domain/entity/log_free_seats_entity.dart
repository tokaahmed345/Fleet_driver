class FreeSeatsLogEntity {
  final String stationId;
  final String stationName;
  final String routeId;
  final int freeSeats;
  final DateTime timestamp;
  final bool synced;

  const FreeSeatsLogEntity({
    required this.stationId,
    required this.stationName,
    required this.routeId,
    required this.freeSeats,
    required this.timestamp,
    this.synced = false,
  });
}