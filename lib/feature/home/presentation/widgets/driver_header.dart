import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/function/helpers.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:fleet_driver/feature/home/presentation/widgets/online_ship.dart';
import 'package:flutter/material.dart';

class DriverHeader extends StatelessWidget {
  const DriverHeader({super.key, required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary,
          child: Text(Helpers.getInitials(userName), style: AppStyle.text16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: AppStyle.text18),
            ],
          ),
        ),
        const OnlineChip(),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => Helpers.showLogoutDialog(context),
          icon: const Icon(Icons.logout, color: AppColors.textSecondary, size: 22),
        ),
      ],
    );
  }
}