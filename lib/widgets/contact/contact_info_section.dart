import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:share_plus/share_plus.dart';
import 'contact_info_tile.dart';

class ContactInfoSection extends StatelessWidget {
  final Contact contact;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onEmail;

  const ContactInfoSection({
    super.key,
    required this.contact,
    required this.onCall,
    required this.onMessage,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ContactInfoTile(
            icon: Icons.phone,
            title: 'Mobile',
            subtitle: contact.phoneNumber,
            onTap: onCall,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.message, color: Colors.blue.shade700, size: 20), onPressed: onMessage),
                IconButton(icon: Icon(Icons.call, color: Colors.green.shade700, size: 20), onPressed: onCall),
              ],
            ),
          ),
          if (contact.email != null && contact.email!.isNotEmpty)
            ContactInfoTile(
              icon: Icons.email,
              title: 'Email',
              subtitle: contact.email!,
              onTap: onEmail,
              trailing: IconButton(icon: Icon(Icons.email, color: Colors.red.shade700, size: 20), onPressed: onEmail),
            ),
          ContactInfoTile(
            icon: Icons.share,
            title: 'Share contact',
            subtitle: 'Via message, email, or social',
            onTap: () {
              final String contactInfo = 'Name: ${contact.name}\nPhone: ${contact.phoneNumber}${contact.email != null ? '\nEmail: ${contact.email}' : ''}';
              Share.share(contactInfo, subject: 'Contact Information: ${contact.name}');
            },
          ),
          ContactInfoTile(
            icon: Icons.block,
            title: 'Block contact',
            subtitle: 'Add to block list',
            onTap: () {},
            isLast: true,
          ),
        ],
      ),
    );
  }
}
