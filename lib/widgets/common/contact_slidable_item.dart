import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/widgets/common/expandable_contact_item.dart';

class ContactSlidableItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final String? timestamp;
  final String? badge;
  final bool showChevron;
  final String? groupTag;
  final List<SlidableAction>? actions;

  const ContactSlidableItem({
    Key? key,
    required this.contact,
    required this.onTap,
    this.timestamp,
    this.badge,
    this.showChevron = false,
    this.groupTag,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableContactItem(
      contact: contact,
      onViewContact: onTap,
      timestamp: timestamp,
      badge: badge,
      showChevron: showChevron,
      groupTag: groupTag,
      actions: actions,
    );
  }
}
