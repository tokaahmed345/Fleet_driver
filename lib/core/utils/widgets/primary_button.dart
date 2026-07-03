
import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.height = 58,
    this.color,
  });

  final String label;
  final VoidCallback? onTap; 
  final IconData? icon;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;
    final bg = isDisabled
        ? AppColors.greyColor.withOpacity(.1) 
        : (color ?? AppColors.primary);

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap, 
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: bg.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: AppColors.background),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppStyle.text18.copyWith(
                    color:isDisabled? AppColors.greyColor.withOpacity(.1): AppColors.background,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}