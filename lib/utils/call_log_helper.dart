import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:intl/intl.dart';

class CallLogStatistics {
  final Map<String, int> callTypeCount;
  final int totalDuration;
  final int totalCalls;

  CallLogStatistics({
    required this.callTypeCount,
    required this.totalDuration,
    required this.totalCalls,
  });
}

class CallLogHelper {
  // Call type colors
  static final Map<CallType, Color> _callTypeColors = {
    CallType.incoming: Colors.green,
    CallType.outgoing: Colors.blue,
    CallType.missed: Colors.red,
    CallType.rejected: Colors.orange,
    CallType.blocked: Colors.grey,
    CallType.unknown: Colors.purple,
  };

  static final Map<String, Color> _callTypeNameColors = {
    'Incoming': Colors.green,
    'Outgoing': Colors.blue,
    'Missed': Colors.red,
    'Rejected': Colors.orange,
    'Blocked': Colors.grey,
    'Unknown': Colors.purple,
  };

  /// Format duration in seconds to a readable string
  static String formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '$minutes min${remainingSeconds > 0 ? ' $remainingSeconds sec' : ''}';
    } else {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      return '$hours hr${minutes > 0 ? ' $minutes min' : ''}';
    }
  }

  /// Format timestamp to a readable string
  static String formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      // Today - show time
      return 'Today, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays < 7) {
      // This week - show day of week
      return DateFormat('EEEE, jm').format(date);
    } else {
      // Older - show date
      return DateFormat('MMM d, yyyy, jm').format(date);
    }
  }

  /// Get text representation of call type
  static String getCallTypeText(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return 'Incoming';
      case CallType.outgoing:
        return 'Outgoing';
      case CallType.missed:
        return 'Missed';
      case CallType.rejected:
        return 'Rejected';
      case CallType.blocked:
        return 'Blocked';
      case CallType.unknown:
        return 'Unknown';
      default:
        return 'Unknown';
    }
  }

  /// Get icon for call type
  static IconData getCallTypeIcon(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_missed;
      case CallType.rejected:
        return Icons.call_end;
      case CallType.blocked:
        return Icons.block;
      case CallType.unknown:
        return Icons.call;
      default:
        return Icons.call;
    }
  }

  /// Get color for call type
  static Color getCallTypeColor(CallType? callType) {
    if (callType == null) return Colors.grey;
    return _callTypeColors[callType] ?? Colors.grey;
  }

  /// Get color for call type by name
  static Color getCallTypeColorByName(String callType) {
    return _callTypeNameColors[callType] ?? Colors.grey;
  }

  /// Calculate statistics from call logs
  static CallLogStatistics calculateStatistics(List<CallLogEntry> logs) {
    // Initialize statistics
    final Map<String, int> callTypeCount = {
      'Incoming': 0,
      'Outgoing': 0,
      'Missed': 0,
      'Rejected': 0,
      'Blocked': 0,
      'Unknown': 0,
    };
    int totalDuration = 0;
    final int totalCalls = logs.length;

    // Calculate statistics
    for (var log in logs) {
      // Count by call type
      final callType = getCallTypeText(log.callType);
      callTypeCount[callType] = (callTypeCount[callType] ?? 0) + 1;

      // Sum duration (only for completed calls)
      if (log.callType == CallType.incoming || log.callType == CallType.outgoing) {
        totalDuration += log.duration ?? 0;
      }
    }

    return CallLogStatistics(
      callTypeCount: callTypeCount,
      totalDuration: totalDuration,
      totalCalls: totalCalls,
    );
  }
}
