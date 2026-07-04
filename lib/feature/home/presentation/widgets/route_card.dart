
import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:fleet_driver/feature/home/domain/entity/driver_route_entity.dart';
import 'package:flutter/material.dart';

class RouteCard extends StatelessWidget {
  final DriverRouteEntity route;
  final int currentStationIndex;

  const RouteCard({
    super.key,
    required this.route,
    required this.currentStationIndex,
  });

  @override
  Widget build(BuildContext context) {
    final stations = route.stations;

    final nextStation = (currentStationIndex + 1 < stations.length)
        ? stations[currentStationIndex + 1]
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${route.id} ',
            style: AppStyle.text16.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(route.name, style: AppStyle.text28),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Next stop',
                style: AppStyle.text16.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                nextStation != null ? nextStation.name : 'End of route',
                style: AppStyle.text16.copyWith(fontSize: 14),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward,
                  color: AppColors.textPrimary, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}