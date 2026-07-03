import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final TextStyle? valueStyle;
  final CrossAxisAlignment alignment;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.valueColor = AppColors.primary,
    this.valueStyle,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            value,
            style: (valueStyle ?? AppStyle.text20).copyWith(
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppStyle.text16.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            textAlign: alignment == CrossAxisAlignment.center
                ? TextAlign.center
                : TextAlign.start,
          ),
        ],
      ),
    );
  }
}