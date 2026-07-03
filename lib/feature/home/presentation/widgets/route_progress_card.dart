
import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:fleet_driver/feature/home/domain/entity/driver_route_entity.dart';
import 'package:fleet_driver/feature/home/presentation/widgets/route_steps_dot.dart';
import 'package:flutter/material.dart';

class RouteProgressCard extends StatelessWidget {
  final DriverRouteEntity route;
  final int currentStationIndex;

  const RouteProgressCard({
    super.key,
    required this.route,
    required this.currentStationIndex,
  });

  @override
  Widget build(BuildContext context) {
    final stationNames = route.stations.map((s) => s.name).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ROUTE PROGRESS',
            style: AppStyle.text16.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 18),
          _RouteStepsRow(
            steps: stationNames,
            currentStepIndex: currentStationIndex,
          ),
        ],
      ),
    );
  }
}

class _RouteStepsRow extends StatelessWidget {
  final List<String> steps;
  final int currentStepIndex;

  const _RouteStepsRow({
    required this.steps,
    required this.currentStepIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStepIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted
                  ? AppColors.success
                  : AppColors.surfaceBorder,
            ),
          );
        }
        final stepIndex = index ~/ 2;
        return RouteStepDot(
          label: steps[stepIndex],
          isDone: stepIndex < currentStepIndex,
          isActive: stepIndex == currentStepIndex,
        );
      }),
    );
  }
}