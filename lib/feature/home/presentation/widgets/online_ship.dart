import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/service/web_socket_simulator_service.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:flutter/material.dart';

class OnlineChip extends StatelessWidget {
  const OnlineChip({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SocketConnectionState>(
      stream: getIt<LiveUpdatesSimulatorService>().connectionState,
      initialData: SocketConnectionState.connecting,
      builder: (context, snapshot) {
        final state = snapshot.data ?? SocketConnectionState.connecting;

        final isConnected = state == SocketConnectionState.connected;
        final isConnecting = state == SocketConnectionState.connecting;

        final Color color = isConnected
            ? AppColors.success
            : isConnecting
                ? AppColors.warning
                : AppColors.danger;

        final Color bgColor = isConnected
            ? AppColors.successBg
            : isConnecting
                ? AppColors.warningBg
                : AppColors.dangerBg;

        final String label = isConnected
            ? 'Online'
            : isConnecting
                ? 'Connecting...'
                : 'Reconnecting...';

        final IconData icon = isConnected ? Icons.wifi : Icons.wifi_off;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppStyle.text16.copyWith(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}