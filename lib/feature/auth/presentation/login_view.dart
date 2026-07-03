import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/feature/auth/presentation/login_cubit/log_in_cubit.dart';
import 'package:fleet_driver/feature/auth/presentation/widgets/driver/login_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return
     Scaffold(body: BlocProvider(
        create: (context) => getIt.get<LogInCubit>(),
        child: LoginViewBody(),
      ));
  
  }
}
