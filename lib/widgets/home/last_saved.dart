// widgets/search/last_saved_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/screens/contact_details_screen.dart';
import 'package:last_save/services/device_contacts_service.dart';
import 'package:last_save/widgets/search/contact_item.dart';

class LastSavedSection extends StatefulWidget {
  const LastSavedSection({super.key});

  @override
  State<LastSavedSection> createState() => _LastSavedSectionState();
}

class _LastSavedSectionState extends State<LastSavedSection> {
  final DeviceContactsService _deviceContactsService = DeviceContactsService();
  List<Contact> _recentContacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentContacts();
  }

  Future<void> _fetchRecentContacts() async {
    final allContacts = await _deviceContactsService.getDeviceContacts();

    // Sort contacts by timestamp (most recent first)
    // Contacts without a timestamp will be at the end
    final sortedContacts = List<Contact>.from(allContacts);
    sortedContacts.sort((a, b) {
      if (a.savedTimestamp == null && b.savedTimestamp == null) {
        return 0; // Both have no timestamp, keep original order
      } else if (a.savedTimestamp == null) {
        return 1; // a has no timestamp, b comes first
      } else if (b.savedTimestamp == null) {
        return -1; // b has no timestamp, a comes first
      } else {
        return b.savedTimestamp!.compareTo(a.savedTimestamp!); // Most recent first
      }
    });

    // Take the first 10 contacts
    final recent = sortedContacts.take(10).toList();

    setState(() {
      _recentContacts = recent;
      _isLoading = false;
    });
  }

  // Format the timestamp for display
  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) {
      return '';
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    if (dateToCheck == today) {
      // Today, show only time
      return 'Today, ${DateFormat.jm().format(timestamp)}';
    } else if (dateToCheck == yesterday) {
      // Yesterday, show "Yesterday" and time
      return 'Yesterday, ${DateFormat.jm().format(timestamp)}';
    } else if (now.difference(timestamp).inDays < 7) {
      // Within the last week, show day of week and time
      return '${DateFormat.E().format(timestamp)}, ${DateFormat.jm().format(timestamp)}';
    } else {
      // Older than a week, show date and time
      return DateFormat('MMM d, ${timestamp.year == now.year ? '' : 'yyyy, '}h:mm a').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last saved',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FC), 
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [ 
                    ..._recentContacts.map(
                      (contact) => ContactItemWithTimestamp(
                        contact: contact,
                        timestamp: _formatTimestamp(contact.savedTimestamp),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContactViewScreen(contact: contact),
                            ));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
  }
}

// Create a new widget that extends ContactItem to show the timestamp
class ContactItemWithTimestamp extends StatelessWidget {
  final Contact contact;
  final String timestamp;
  final VoidCallback onTap;

  const ContactItemWithTimestamp({
    Key? key,
    required this.contact,
    required this.timestamp,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar or placeholder
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              backgroundImage: contact.photo != null ? MemoryImage(contact.photo!) : null,
              child: contact.photo == null
                  ? Text(
                      contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.black54),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            
            // Contact name and details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (contact.phoneNumber.isNotEmpty)
                    Text(
                      contact.phoneNumber,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (timestamp.isNotEmpty)
                    Text(
                      timestamp,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),            
          ],
        ),
      ),
    );
  }
}