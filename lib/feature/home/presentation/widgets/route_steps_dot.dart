
import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:flutter/material.dart';


class RouteStepDot extends StatelessWidget {
  final String label;
  final bool isDone;
  final bool isActive;

  const RouteStepDot({
    super.key,
    required this.label,
    required this.isDone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? AppColors.success          
                : isActive
                    ? AppColors.surface       
                    : AppColors.surfaceElevated,
            border: isActive
                ? Border.all(color: AppColors.info, width: 2)   
                : null,
          ),
          child: isDone
              ? const Icon(Icons.check, color: AppColors.whiteColor, size: 16)
              : isActive
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.info,       
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 56,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.text16.copyWith(
              fontSize: 11,
              color: isActive ? AppColors.textPrimary : AppColors.textMuted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}