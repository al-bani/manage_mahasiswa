import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep; // step aktif sekarang (0, 1, 2)
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          bool isActive = stepIndex <= currentStep;

          return _buildCircle(isActive);
        } else {
          int lineIndex = (index - 1) ~/ 2;
          bool isActive = lineIndex < currentStep;

          return _buildLine(isActive);
        }
      }),
    );
  }

  Widget _buildCircle(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isActive ? 22 : 16,
      height: isActive ? 22 : 16,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive ? AppColors.primary : Colors.grey.shade300,
        ),
      ),
    );
  }
}
