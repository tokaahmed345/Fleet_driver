import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/core/utils/sharedprefrence.dart';
import 'package:fleet_driver/feature/auth/domain/entity/login_entity.dart';
import 'package:fleet_driver/feature/auth/domain/usecase/login_usecase.dart';


part 'log_in_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit() : super(LogInInitial());
logIn({ required String email, required String password})async{
    emit(LogInLoading());
 final result=  await getIt.get<LogInUseCase>().call( email: email, password: password);
 result.fold((fail) => emit(LogInFailure(errorMessage: fail.message)),  (user)async {
 await  getIt.get<SharedPrefs>().saveUser(
      id: user.id,
      role: user.role,
      name: user.name,
    driverId: user.driverId, 

    );
     emit(LogInSuccess( logInEntity: user));

 });
 

  }


}
