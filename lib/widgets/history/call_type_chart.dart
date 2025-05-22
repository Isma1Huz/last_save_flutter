import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:last_save/utils/call_log_helper.dart';

class CallTypeChart extends StatelessWidget {
  final Map<String, int> callTypeCount;

  const CallTypeChart({
    Key? key,
    required this.callTypeCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredData = callTypeCount.entries
        .where((entry) => entry.value > 0)
        .toList();
    
    if (filteredData.isEmpty) {
      return const Center(
        child: Text('No call data available'),
      );
    }
    
    return PieChart(
      PieChartData(
        sections: _getPieChartSections(filteredData),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections(List<MapEntry<String, int>> data) {
    final List<PieChartSectionData> sections = [];
    
    for (int i = 0; i < data.length; i++) {
      final entry = data[i];
      final color = CallLogHelper.getCallTypeColorByName(entry.key);
      
      sections.add(
        PieChartSectionData(
          value: entry.value.toDouble(),
          title: '${entry.value}',
          color: color,
          radius: 80,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    }
    
    return sections;
  }
}

class CallTypeLegend extends StatelessWidget {
  final Map<String, int> callTypeCount;

  const CallTypeLegend({
    Key? key,
    required this.callTypeCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final filteredData = callTypeCount.entries
        .where((entry) => entry.value > 0)
        .toList();
    
    if (filteredData.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: filteredData.map((entry) {
        final color = CallLogHelper.getCallTypeColorByName(entry.key);
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${entry.key}: ${entry.value}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
