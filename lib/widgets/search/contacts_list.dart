import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/widgets/common/contact_slidable_item.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;
  final Function(Contact) onContactTap;
  final List<SlidableAction>? Function(Contact)? actionsBuilder;
  final String? Function(Contact)? badgeBuilder;
  final String? Function(Contact)? timestampBuilder;
  final bool showChevron;

  const ContactsList({
    super.key,
    required this.contacts,
    required this.onContactTap,
    this.actionsBuilder,
    this.badgeBuilder,
    this.timestampBuilder,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: contacts.length,
      padding: const EdgeInsets.symmetric(vertical: 8 , horizontal: 10),
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Card(
           color: theme.brightness == Brightness.light
              ? theme.cardColor
              : theme.cardColor,
          elevation: theme.brightness == Brightness.light ? 0 : 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          child: ContactSlidableItem(
          contact: contact,
          onTap: () => onContactTap(contact),
          timestamp: timestampBuilder != null ? timestampBuilder!(contact) : null,
          badge: badgeBuilder != null ? badgeBuilder!(contact) : null,
          showChevron: showChevron,
          actions: actionsBuilder != null ? actionsBuilder!(contact) : null,
        ));
      },
    );
  }
}
