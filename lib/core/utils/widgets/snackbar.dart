import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

Future<void> showSnackBarFuction(
  BuildContext context,
  String text, {
  required bool isError,
  Color? color,
  IconData? icon,
}) {
  final resolvedColor = color ?? (isError ? AppColors.redColor : Colors.green);
  final resolvedIcon = icon ?? (isError ? Icons.error_outline : Icons.check_circle_outline);

  ScaffoldMessenger.of(context).clearSnackBars();

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: resolvedColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(resolvedIcon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ),
    ),
  ).closed;
}