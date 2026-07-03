part of 'register_driver_cubit.dart';

sealed class RegisterDriverState extends Equatable {
  const RegisterDriverState();

  @override
  List<Object> get props => [];
}


class RegisterDriverInitial extends RegisterDriverState {}

class RegisterDriverLoading extends RegisterDriverState {}

class RegisterDriverSuccess extends RegisterDriverState {
  final RegisterDriverEntity driver;
  const RegisterDriverSuccess(this.driver);
  
  @override
  List<Object> get props => [driver];
}

class RegisterDriverFailure extends RegisterDriverState {
  final String message;
  const RegisterDriverFailure(this.message);
   @override
  List<Object> get props => [message];
}