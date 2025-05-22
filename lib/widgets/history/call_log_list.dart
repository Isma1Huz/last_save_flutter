import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:last_save/widgets/history/call_log_item.dart';

class CallLogList extends StatelessWidget {
  final List<CallLogEntry> callLogs;

  const CallLogList({
    Key? key,
    required this.callLogs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (callLogs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.call_missed_outgoing,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No call history found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: callLogs.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return CallLogItem(log: callLogs[index]);
      },
    );
  }
}
