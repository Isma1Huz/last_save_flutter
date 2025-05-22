import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/screens/contact_history_screen.dart';

/// Helper class for contact-related actions like calling, messaging, etc.
class ContactActionsHelper {
  /// Make a phone call to the given phone number
  static Future<void> makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone app')),
      );
    }
  }

  /// Send a text message to the given phone number
  static Future<void> sendMessage(BuildContext context, String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch messaging app')),
      );
    }
  }

  /// Make a phone call using the alternative method
  static Future<void> makePhoneCallAlternative(BuildContext context, String phoneNumber) async {
    // Clean the phone number - remove any non-digit characters except +
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Try using tel: URI first
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);
    
    try {
      // Try to launch with external application mode
      final launched = await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        // If that fails, try a direct URL
        final directUri = Uri.parse('tel:$cleanedNumber');
        final directLaunched = await launchUrl(
          directUri,
          mode: LaunchMode.externalApplication,
        );
        
        if (!directLaunched && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch phone app')),
          );
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  /// Send a message using the alternative method
  static Future<void> sendMessageAlternative(BuildContext context, String phoneNumber) async {
    // Clean the phone number - remove any non-digit characters except +
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Try using sms: URI first
    final Uri smsUri = Uri(scheme: 'sms', path: cleanedNumber);
    
    try {
      // Try to launch with external application mode
      final launched = await launchUrl(
        smsUri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        // If that fails, try a direct URL
        final directUri = Uri.parse('sms:$cleanedNumber');
        final directLaunched = await launchUrl(
          directUri,
          mode: LaunchMode.externalApplication,
        );
        
        if (!directLaunched && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch messaging app')),
          );
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  /// Open video call app (if available)
  static Future<void> makeVideoCall(BuildContext context, String phoneNumber) async {
    // This is a placeholder. Different platforms and apps handle video calls differently.
    // You might need to integrate with a specific video calling app or service.
    
    // For example, to open WhatsApp video call (if installed):
    // final whatsappUri = Uri.parse('whatsapp://call?phone=$phoneNumber&video=1');
    
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video call functionality not implemented')),
    );
  }

  /// Open call history for a specific contact
  static void openCallHistory(BuildContext context, Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactHistoryScreen(contact: contact),
      ),
    );
  }
}
