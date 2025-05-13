// widgets/contact/contact_info_tile.dart
import 'package:flutter/material.dart';

class ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isLast;
  final bool isMultiLine;

  const ContactInfoTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.isLast = false,
    this.isMultiLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black87, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              maxLines: isMultiLine ? 10 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: trailing,
          onTap: onTap,
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 72,
            endIndent: 16,
          ),
      ],
    );
  }
}