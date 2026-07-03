part of 'seats_cubit.dart';

sealed class SeatsState extends Equatable {
  const SeatsState();

  @override
  List<Object> get props => [];
}

final class SeatsInitial extends SeatsState {}


final class SeatsCheckingLocation extends SeatsState {}

final class SeatsWithinRange extends SeatsState {
  final double distance;
  const SeatsWithinRange(this.distance);

  @override
  List<Object> get props => [distance];
}

final class SeatsOutOfRange extends SeatsState {
  final double distance;
  const SeatsOutOfRange(this.distance);

  @override
  List<Object> get props => [distance];
}

final class SeatsLocationError extends SeatsState {
  final String message;
  const SeatsLocationError(this.message);

  @override
  List<Object> get props => [message];
}


final class SeatsSubmitLoading extends SeatsState {}

final class SeatsSubmitSuccess extends SeatsState {
  final bool synced; 
  const SeatsSubmitSuccess(this.synced);

  @override
  List<Object> get props => [synced];
}

final class SeatsSubmitError extends SeatsState {
  final String message;
  const SeatsSubmitError(this.message);

  @override
  List<Object> get props => [message];
}