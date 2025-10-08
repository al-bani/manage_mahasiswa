import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';

Widget cardSummary(String title, String value, String subtitle) {
  return Container(
    width: 200,
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.1),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.openSansBold(
              fontSize: 14, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.openSansBold(
              fontSize: 27, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextStyles.openSansItalic(
              fontSize: 10, color: AppColors.primary),
        ),
      ],
    ),
  );
}

class CardLandscape extends StatefulWidget {
  final String city;
  final int count;
  const CardLandscape({super.key, required this.city, required this.count});

  @override
  State<CardLandscape> createState() => _CardLandscapeState();
}

class _CardLandscapeState extends State<CardLandscape> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        scale: _pressed ? 1.06 : 1.0,
        child: Container(
          height: 150,
          width: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.count.toString(),
                style: AppTextStyles.openSansBold(
                    fontSize: 30, color: AppColors.secondary),
              ),
              const SizedBox(height: 3),
              Text(
                widget.city,
                style: AppTextStyles.openSansItalic(
                    fontSize: 12, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
