import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/function/helpers.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:fleet_driver/feature/register_driver/presentation/cubits/cubit/routes_cubit.dart';
import 'package:fleet_driver/feature/register_driver/presentation/cubits/register_cubit/register_driver_cubit.dart';
import 'package:fleet_driver/feature/register_driver/presentation/widgets/register_driver_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegisterDriverView extends StatelessWidget {
  const RegisterDriverView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt.get<RegisterDriverCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<RoutesCubit>()..getRoutes(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
     
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Text('Register New Driver', style: AppStyle.text18),
                IconButton(
          onPressed: () => Helpers.showLogoutDialog(context),
          icon: const Icon(Icons.logout, color: AppColors.textSecondary, size: 22),
        ),
            ],
          ),
        ),
        body: const RegisterDriverViewBody(),
      ),
    );
  }
}