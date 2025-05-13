import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/utils/app_theme.dart';

class ContactAvatar extends StatelessWidget {
  final Contact contact;

  const ContactAvatar({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    if (contact.photo != null) {
      return CircleAvatar(
        backgroundImage: MemoryImage(contact.photo!),
      );
    }
    
    return CircleAvatar(
      backgroundColor: AppTheme.primaryColor,
      child: Text(
        contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
