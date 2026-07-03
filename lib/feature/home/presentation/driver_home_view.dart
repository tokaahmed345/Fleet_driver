import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/feature/home/presentation/cubits/driver_route_cubit/driver_route_cubit.dart';
import 'package:fleet_driver/feature/home/presentation/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider.value(
        value: getIt<DriverRouteCubit>(),
        child: const DriverHomeViewBody(),
      ),
    );
  }
}