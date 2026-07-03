
import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:fleet_driver/feature/log_free_seats/presentation/cubits/pending_logas_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingLogsBanner extends StatelessWidget {
  const PendingLogsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<PendingLogsCubit>(),
      child: BlocBuilder<PendingLogsCubit, int>(
        bloc: getIt<PendingLogsCubit>(),
        builder: (context, pendingCount) {
          if (pendingCount == 0) return const SizedBox.shrink();

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.warning,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$pendingCount ${pendingCount == 1 ? 'log' : 'logs'} pending sync — will upload when online',
                    style: AppStyle.text16.copyWith(
                      color: AppColors.warning,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
