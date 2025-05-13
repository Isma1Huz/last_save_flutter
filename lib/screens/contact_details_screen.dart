import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/widgets/contact/contact_action_buttons.dart';
import 'package:last_save/widgets/contact/contact_header.dart';
import 'package:last_save/widgets/contact/contact_info_section.dart';

import 'package:url_launcher/url_launcher.dart';

class ContactViewScreen extends StatelessWidget {
  final Contact contact;

  const ContactViewScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8ECF4),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(icon: const Icon(Icons.edit, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black), onPressed: () => _showOptionsMenu(context)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            ContactHeader(contact: contact),
            const SizedBox(height: 16),
            ContactActionButtons(
              onCall: () => _makePhoneCall(contact.phoneNumber),
              onMessage: () => _sendSMS(contact.phoneNumber),
              onVideo: () {},
              onEmail: () => _sendEmail(contact.email),
            ),
            const SizedBox(height: 16),
            ContactInfoSection(
              contact: contact,
              onCall: () => _makePhoneCall(contact.phoneNumber),
              onMessage: () => _sendSMS(contact.phoneNumber),
              onEmail: () => _sendEmail(contact.email),
            ),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _sendSMS(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _sendEmail(String? email) async {
    if (email == null || email.isEmpty) return;
    final Uri uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.delete), title: const Text('Delete contact'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.star_outline), title: const Text('Add to favorites'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.history), title: const Text('View call history'), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
