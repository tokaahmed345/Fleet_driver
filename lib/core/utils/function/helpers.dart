import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/router/routes_name.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/core/utils/sharedprefrence.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Helpers {
 static String getInitials(String name) {
  final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '';
  if (parts.length == 1) {
    return parts[0].substring(0, 1); 
  }
  return parts[0].substring(0, 1) + parts[1].substring(0, 1); 
}
  static Future<void> showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title:  Text('Logout',style: AppStyle.text16,),
        content:  Text('Are you sure you want to logout?',style: AppStyle.text16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _logout(context);
    }
  }

  static Future<void> _logout(BuildContext context) async {
    await getIt.get<SharedPrefs>().clearUser();

    if (context.mounted) {
      GoRouter.of(context).go(RoutesName.logIn);
    }
  }
static IconData iconForUpdateType(String type) {
    switch (type) {
      case 'station_closed':
        return Icons.block_rounded;
      case 'congestion':
        return Icons.traffic_rounded;
      case 'delay':
        return Icons.schedule_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }
 
  static Color colorForUpdateType(String type) {
    switch (type) {
      case 'station_closed':
        return AppColors.danger; 
      case 'congestion':
        return AppColors.info ;
      case 'delay':
        return AppColors.warning; 
      default:
        return AppColors.primary; 
    }
  }
}