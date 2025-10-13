import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';

class ButtonForm extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const ButtonForm({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ?? AppColors.primary, // Warna berbeda untuk back
        foregroundColor: textColor ?? AppColors.secondary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.openSansBold(
          fontSize: 16,
          color: textColor ?? AppColors.secondary,
        ),
      ),
    );
  }
}
