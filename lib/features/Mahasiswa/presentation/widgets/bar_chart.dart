import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';

Widget barChart(
    BuildContext context, Color color, String title, int value, int total) {
  final double percentage = value / total;

  return Padding(
    padding: const EdgeInsets.only(right: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.openSansBold(
                color: AppColors.primary,
                fontSize: 12,
              ),
            ),
            Text(
              value.toString(),
              style: AppTextStyles.openSansItalic(
                color: AppColors.primary,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(
              height: 10,
              width: MediaQuery.of(context).size.width * percentage,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
