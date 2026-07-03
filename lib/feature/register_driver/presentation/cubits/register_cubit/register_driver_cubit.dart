import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fleet_driver/feature/register_driver/domain/entity/register_driver_entity.dart';
import 'package:fleet_driver/feature/register_driver/domain/usecase/register_driver_usecase.dart';

part 'register_driver_state.dart';

class RegisterDriverCubit extends Cubit<RegisterDriverState> {
    final RegisterDriverUseCase useCase;

  RegisterDriverCubit(this.useCase) : super(RegisterDriverInitial());
   Future<void> register({
    required String name,
    required String email,
    required String password,
    required String route,
  }) async {
    emit(RegisterDriverLoading());

    final result = await useCase.call(
      name: name,
      email: email,
      password: password,
      route: route,
    );

    result.fold(
      (failure) => emit(RegisterDriverFailure(failure.message)),
      (driver) => emit(RegisterDriverSuccess(driver)),
    );
  }
}
