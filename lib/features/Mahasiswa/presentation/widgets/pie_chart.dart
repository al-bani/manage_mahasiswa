// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';

class GenderPieChart extends StatefulWidget {
  final Map<String, Map<String, Object>> gender;

  const GenderPieChart({
    super.key,
    required this.gender,
  });

  @override
  State<GenderPieChart> createState() => _GenderPieChartState();
}

class _GenderPieChartState extends State<GenderPieChart> {
  int? touchedIndex;

  List<PieChartSectionData> _sections() {
    return [
      PieChartSectionData(
        color: widget.gender["L"]?["colors"] as Color? ?? Colors.blue,
        value: (widget.gender["L"]?["value"] as num?)?.toDouble() ?? 0,
        title:
            '${((widget.gender["L"]?["value"] as num?)?.toDouble() ?? 0).toInt()}%',
        radius: touchedIndex == 0 ? 70 : 60,
        titleStyle: AppTextStyles.openSansBold(
          color: AppColors.white,
          fontSize: 14,
        ),
      ),
      PieChartSectionData(
        color: widget.gender["P"]?["colors"] as Color? ?? Colors.pink,
        value: (widget.gender["P"]?["value"] as num?)?.toDouble() ?? 0,
        title:
            '${((widget.gender["P"]?["value"] as num?)?.toDouble() ?? 0).toInt()}%',
        radius: touchedIndex == 1 ? 70 : 60,
        titleStyle: AppTextStyles.openSansBold(
          color: AppColors.white,
          fontSize: 14,
        ),
      ),
    ];
  }

  Widget _legendItem(
      {required Color color, required String label, required bool selected}) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: selected ? 1 : 0.6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        margin: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: selected ? color : Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.openSansItalic(
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 60,
                    sectionsSpace: 2,
                    startDegreeOffset: -90,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.touchedSection == null) {
                          setState(() => touchedIndex = null);
                          return;
                        }
                        setState(() => touchedIndex =
                            response.touchedSection!.touchedSectionIndex);
                      },
                    ),
                    sections: _sections(),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gender',
                    style: AppTextStyles.openSansBold(
                      color: AppColors.primary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _legendItem(
                color: widget.gender["L"]?["colors"] as Color? ?? Colors.blue,
                label: widget.gender["L"]?["label"] as String? ?? 'L',
                selected: touchedIndex == 0),
            const SizedBox(height: 8),
            _legendItem(
                color: widget.gender["P"]?["colors"] as Color? ?? Colors.pink,
                label: widget.gender["P"]?["label"] as String? ?? 'P',
                selected: touchedIndex == 1),
          ],
        ),
      ],
    );
  }
}
