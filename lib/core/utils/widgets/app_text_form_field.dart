import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.textInputAction,
    
    this.enabled,
    this.radius,
  });

  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final void Function(String?)? onSaved;
  final TextInputAction? textInputAction;
  final bool? enabled;
  final double? radius;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final radius = widget.radius ?? 16;

    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      cursorColor: AppColors.primary,
      style: AppStyle.text16,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        hintText: widget.hint,
        hintStyle: AppStyle.text16.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
        ),
        errorStyle: AppStyle.text16.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.danger,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
        prefixIcon: Icon(widget.icon, size: 20, color: AppColors.textMuted),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 19,
                  color: AppColors.textMuted,
                ),
                onPressed: () => setState(() => _obscured = !_obscured),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.surfaceBorder, width: 1.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.surfaceBorder, width: 1.4),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.surfaceBorder, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
        ),
      ),
    );
  }
}