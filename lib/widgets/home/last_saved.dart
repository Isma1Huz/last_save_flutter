// lib/widgets/home/last_saved_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/screens/contact_view_screen.dart';
import 'package:last_save/services/device_contacts_service.dart';
import 'package:last_save/widgets/common/contact_avatar.dart';

class LastSavedSection extends StatefulWidget {
  const LastSavedSection({super.key});

  @override
  State<LastSavedSection> createState() => _LastSavedSectionState();
}

class _LastSavedSectionState extends State<LastSavedSection> {
  final DeviceContactsService _deviceContactsService = DeviceContactsService();
  List<Contact> _recentContacts = [];
  bool _isLoading = true;
  final String _slidableGroup = 'lastSavedGroup';

  @override
  void initState() {
    super.initState();
    _fetchRecentContacts();
    _deviceContactsService.onContactsChanged.listen((_) {
      debugPrint('Contacts changed notification received in LastSavedSection');
      _fetchRecentContacts();
    });
  }

  Future<void> _fetchRecentContacts() async {
    debugPrint('Fetching recent contacts...');
    final allContacts = await _deviceContactsService.getDeviceContacts();
    debugPrint('Got ${allContacts.length} contacts, sorting by timestamp...');

    final sortedContacts = List<Contact>.from(allContacts);


    // Debug timestamps
    for (var contact in sortedContacts.take(80)) {
      debugPrint('Contact: ${contact.name}, Timestamp: ${contact.savedTimestamp}');
    }

    final recent = sortedContacts.take(10).toList();

    setState(() {
      _recentContacts = recent;
      _isLoading = false;
    });
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) {
      return '';
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    if (dateToCheck == today) {
      return 'Today, ${DateFormat.jm().format(timestamp)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday, ${DateFormat.jm().format(timestamp)}';
    } else if (now.difference(timestamp).inDays < 7) {
      return '${DateFormat.E().format(timestamp)}, ${DateFormat.jm().format(timestamp)}';
    } else {
      return DateFormat('MMM d, ${timestamp.year == now.year ? '' : 'yyyy, '}h:mm a').format(timestamp);
    }
  }

  List<SlidableAction> _buildContactActions(Contact contact) {
    return [
      SlidableAction(
        onPressed: (_) {
          _handleAddNotes(contact);
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: Icons.note_alt_outlined,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      SlidableAction(
        onPressed: (_) {
          _handleCreateReminder(contact);
        },
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        icon: Icons.notifications_active,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
    ];
  }

  void _handleAddNotes(Contact contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add notes for ${contact.name}')),
    );
  }

  void _handleCreateReminder(Contact contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Create reminder for ${contact.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return _isLoading
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last saved',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? theme.cardColor : const Color(0xFFF8F9FC),
                  ),
                  child: SlidableAutoCloseBehavior(
                    closeWhenOpened: true,
                    closeWhenTapped: true,
                    child: Column(
                      children: [ 
                        ..._recentContacts.map(
                          (contact) => Slidable(
                            key: ValueKey(contact.id),
                            groupTag: _slidableGroup,
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              extentRatio: 0.5,
                              children: _buildContactActions(contact),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isDark 
                                        ? theme.dividerColor 
                                        : Colors.grey.shade200,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                dense: true,
                                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                contentPadding: EdgeInsets.zero,
                                leading: ContactAvatar(contact: contact),
                                title: Text(
                                  contact.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: theme.textTheme.titleMedium?.color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (contact.phoneNumber.isNotEmpty)
                                      Text(
                                        contact.phoneNumber,
                                        style: TextStyle(
                                          color: isDark 
                                              ? theme.textTheme.bodySmall?.color 
                                              : Colors.grey[600],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (_formatTimestamp(contact.savedTimestamp).isNotEmpty)
                                      Text(
                                        _formatTimestamp(contact.savedTimestamp),
                                        style: TextStyle(
                                          color: isDark 
                                              ? theme.textTheme.bodySmall?.color?.withOpacity(0.7) 
                                              : Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContactViewScreen(contact: contact),
                                    ));
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
  }
}