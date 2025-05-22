import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/utils/contact_action_helper.dart';
import 'package:last_save/widgets/common/contact_avatar.dart';
import 'package:last_save/widgets/history/call_log_list.dart';
import 'package:last_save/widgets/history/call_statistics.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactHistoryScreen extends StatefulWidget {
  final Contact contact;

  const ContactHistoryScreen({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  State<ContactHistoryScreen> createState() => _ContactHistoryScreenState();
}

class _ContactHistoryScreenState extends State<ContactHistoryScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<CallLogEntry> _callLogs = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchCallLogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchCallLogs() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      // Request permission
      final status = await Permission.phone.request();
      if (status.isDenied) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Permission to access call logs was denied';
        });
        return;
      }

      final cleanedNumber = widget.contact.phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      
      final Iterable<CallLogEntry> entries = await CallLog.query(
        number: cleanedNumber,
      );

      setState(() {
        _callLogs = entries.toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load call logs: ${e.toString()}';
      });
    }
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchCallLogs,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Row(
          children: [
            ContactAvatar(
              contact: widget.contact,
              size: 36,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contact.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.contact.phoneNumber,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ContactActionsHelper.makePhoneCallAlternative(
                context,
                widget.contact.phoneNumber,
              );
            },
            tooltip: 'Call',
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              ContactActionsHelper.sendMessageAlternative(
                context,
                widget.contact.phoneNumber,
              );
            },
            tooltip: 'Message',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'HISTORY'),
            Tab(text: 'STATISTICS'),
          ],
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: isDark ? Colors.white60 : Colors.grey.shade600,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorView()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    CallLogList(callLogs: _callLogs),
                    CallStatistics(callLogs: _callLogs),
                  ],
                ),
    );
  }
}
