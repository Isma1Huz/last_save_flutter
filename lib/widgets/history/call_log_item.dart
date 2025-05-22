import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:last_save/utils/call_log_helper.dart';
import 'package:last_save/utils/contact_action_helper.dart';

class CallLogItem extends StatelessWidget {
  final CallLogEntry log;

  const CallLogItem({
    Key? key,
    required this.log,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 0,
      color: isDark ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: CallLogHelper.getCallTypeColor(log.callType).withOpacity(0.2),
          child: Icon(
            CallLogHelper.getCallTypeIcon(log.callType),
            color: CallLogHelper.getCallTypeColor(log.callType),
          ),
        ),
        title: Row(
          children: [
            Text(
              CallLogHelper.getCallTypeText(log.callType),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CallLogHelper.getCallTypeColor(log.callType),
              ),
            ),
            const Spacer(),
            if (log.duration != null && log.duration! > 0)
              Text(
                CallLogHelper.formatDuration(log.duration!),
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        subtitle: Text(
          CallLogHelper.formatTimestamp(log.timestamp),
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.call,
            color: theme.colorScheme.primary,
          ),
          onPressed: () {
            ContactActionsHelper.makePhoneCallAlternative(
              context,
              log.number ?? '',
            );
          },
        ),
      ),
    );
  }
}
