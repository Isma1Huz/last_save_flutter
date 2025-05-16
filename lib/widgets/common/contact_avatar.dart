import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';

class ContactAvatar extends StatelessWidget {
  final Contact contact;
  final double size;

  const ContactAvatar({
    super.key,
    required this.contact,
    this.size = 32, 
  });

  @override
  Widget build(BuildContext context) {
    if (contact.photo != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: MemoryImage(contact.photo!),
      );
    }
    
    final initials = _getInitials(contact.name);
    
    return CircleAvatar(
      radius: size / 2,
      backgroundColor:Theme.of(context).primaryColor,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return name[0].toUpperCase();
    }
  }
}
