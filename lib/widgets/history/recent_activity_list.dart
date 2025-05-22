import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:last_save/utils/call_log_helper.dart';

class RecentActivityList extends StatelessWidget {
  final List<CallLogEntry> callLogs;
  final int limit;

  const RecentActivityList({
    Key? key,
    required this.callLogs,
    this.limit = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (callLogs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No recent activity'),
        ),
      );
    }
    
    final recentLogs = callLogs.take(limit).toList();
    
    return Column(
      children: recentLogs.map((log) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: CallLogHelper.getCallTypeColor(log.callType).withOpacity(0.2),
            child: Icon(
              CallLogHelper.getCallTypeIcon(log.callType),
              color: CallLogHelper.getCallTypeColor(log.callType),
              size: 16,
            ),
          ),
          title: Text(
            CallLogHelper.getCallTypeText(log.callType),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            CallLogHelper.formatTimestamp(log.timestamp),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          trailing: log.duration != null && log.duration! > 0
              ? Text(
                  CallLogHelper.formatDuration(log.duration!),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              : null,
        );
      }).toList(),
    );
  }
}
