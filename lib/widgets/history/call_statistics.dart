import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:last_save/utils/call_log_helper.dart';
import 'package:last_save/widgets/history/call_type_chart.dart';
import 'package:last_save/widgets/history/recent_activity_list.dart';
import 'package:last_save/widgets/history/statistics_card.dart';

class CallStatistics extends StatelessWidget {
  final List<CallLogEntry> callLogs;

  const CallStatistics({
    Key? key,
    required this.callLogs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calculate statistics
    final stats = CallLogHelper.calculateStatistics(callLogs);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatisticsCard(
            title: 'Call Summary',
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatItem(
                    title: 'Total Calls',
                    value: stats.totalCalls.toString(),
                    icon: Icons.call,
                    color: theme.colorScheme.primary,
                  ),
                  StatItem(
                    title: 'Total Duration',
                    value: CallLogHelper.formatDuration(stats.totalDuration),
                    icon: Icons.access_time,
                    color: Colors.orange,
                  ),
                  StatItem(
                    title: 'Avg Duration',
                    value: stats.totalCalls > 0
                        ? CallLogHelper.formatDuration(stats.totalDuration ~/ stats.totalCalls)
                        : '0 sec',
                    icon: Icons.timelapse,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          StatisticsCard(
            title: 'Call Types',
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: CallTypeChart(callTypeCount: stats.callTypeCount),
                  ),
                  const SizedBox(height: 16),
                  CallTypeLegend(callTypeCount: stats.callTypeCount),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          StatisticsCard(
            title: 'Recent Activity',
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: RecentActivityList(callLogs: callLogs),
            ),
          ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatItem({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
