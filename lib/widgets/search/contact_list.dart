import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'contact_item.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;
  final Function(Contact) onContactTap;

  const ContactsList({
    super.key,
    required this.contacts,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ContactItem(
          contact: contact,
          onTap: () => onContactTap(contact),
        );
      },
    );
  }
}
