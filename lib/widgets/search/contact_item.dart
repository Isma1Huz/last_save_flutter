import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'contact_avatar.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;

  const ContactItem({
    super.key,
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ContactAvatar(contact: contact),
      title: Text(contact.name),
      subtitle: Text(contact.phoneNumber),
      trailing: contact.email != null ? const Icon(Icons.email) : null,
      onTap: onTap,
    );
  }
}
