import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/services/device_contacts_service.dart';
import 'package:last_save/services/favorite_service.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/utils/contact_action_helper.dart';
import 'package:last_save/widgets/contact/contact_header.dart';
import 'package:last_save/widgets/contact/contact_action_buttons.dart';
import 'package:last_save/widgets/contact/contact_info_section.dart';
import 'package:last_save/widgets/contact/contact_media_section.dart';
import 'package:last_save/widgets/contact/contact_privacy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:last_save/utils/vcf_helper.dart';

class ContactViewScreen extends StatefulWidget {
  final Contact contact;

  const ContactViewScreen({super.key, required this.contact});

  @override
  State<ContactViewScreen> createState() => _ContactViewScreenState();
}

class _ContactViewScreenState extends State<ContactViewScreen> {
  late Contact contact;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  Future<void> _toggleFavorite() async {
    final newStatus = await FavoritesService().toggleFavorite(contact.id);
    setState(() {
      contact = contact.copyWith(isFavorite: newStatus);
    });
    DeviceContactsService().notifyContactsChanged();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final backgroundColor =
        isDarkMode ? AppTheme.darkBackgroundColor : const Color(0xFFF2F2F2);
    final headerColor = isDarkMode ? const Color(0xFF1F2C34) : theme.primaryColor;
    final textColor =
        isDarkMode ? AppTheme.darkTextColorPrimary : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: headerColor,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              contact.isFavorite ? Icons.star : Icons.star_border,
              color: contact.isFavorite ? Colors.amber : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: textColor),
            onSelected: (value) {
              switch (value) {
                case 'share':
                  _shareContact(contact);
                  break;
                case 'qr_code':
                  break;
                case 'favorite':
                  _toggleFavorite();
                  break;
                case 'delete':
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 12),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'qr_code',
                child: Row(
                  children: [
                    Icon(Icons.qr_code, size: 20),
                    SizedBox(width: 12),
                    Text('QR code'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'favorite',
                child: Row(
                  children: [
                    Icon(contact.isFavorite ? Icons.star : Icons.star_border,
                    color: contact.isFavorite ? Colors.amber : null, size: 20),
                    const SizedBox(width: 12),
                    Text(contact.isFavorite ? 'Remove from favorites' : 'Add to favorites'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete contact', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: headerColor,
              child: Column(
                children: [
                  ContactHeader(contact: contact),
                  const SizedBox(height: 16),
                  ContactActionButtons(
                    onCall: () => _makePhoneCall(context, contact.phoneNumber),
                    onMessage: () => _sendSMS(context, contact.phoneNumber),
                    onEmail: () => _sendEmail(context, contact.email),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ContactInfoSection(
              contact: contact,
              onCall: () => _makePhoneCall(context, contact.phoneNumber),
              onMessage: () => _sendSMS(context, contact.phoneNumber),
              onEmail: () => _sendEmail(context, contact.email),
            ),
            const SizedBox(height: 8),
            ContactMediaSection(contact: contact),
            const SizedBox(height: 8),
            ContactPrivacySection(contact: contact),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(BuildContext context, String phoneNumber) {
    ContactActionsHelper.makePhoneCallAlternative(context, phoneNumber);
  }

  void _sendSMS(BuildContext context, String phoneNumber) {
    ContactActionsHelper.sendMessageAlternative(context, phoneNumber);
  }


  void _sendEmail(BuildContext context, String? email) {
    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email address available')),
      );
      return;
    }
    
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Hello',
      },
    );
    
    try {
      launchUrl(emailUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch email app: $e')),
      );
    }
  }

  Future<void> _shareContact(Contact contact) async {
    await VcfHelper.shareContact(context, contact);
  }
}
