import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:last_save/widgets/create/addresses_section.dart';
import 'package:last_save/widgets/create/email_section.dart';
import 'package:last_save/widgets/create/phone_number.dart';

class ContactsService {
  static Future<bool> saveContact({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String company,
    required List<PhoneNumberField> phoneNumbers,
    required List<EmailField> emails,
    required List<AddressField> addresses,
    required String? category,
    required String? notes,
    required String? meetingEvent,
    required File? profileImage,
  }) async {
    try {
      if (!await FlutterContacts.requestPermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contacts permission denied'))
        );
        return false;
      }

      final newContact = Contact();
      newContact.name.first = firstName;
      newContact.name.last = lastName;

      if (company.isNotEmpty) {
        newContact.organizations = [Organization(company: company)];
      }

      final now = DateTime.now();
      final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      newContact.events = [
        Event(
          year: now.year,
          month: now.month,
          day: now.day,
          label: EventLabel.other,
          customLabel: "Saved on: $formattedDateTime"
        )
      ];

      // === Add NOTES including saved time, category, event, and user notes ===
      List<String> noteLines = [];

      // Always add saved timestamp at the top
      noteLines.add("Saved on: $formattedDateTime");

      if (notes != null && notes.isNotEmpty) {
        noteLines.add("\nNote: $notes");
      }

      if (meetingEvent != null && meetingEvent.isNotEmpty) {
        noteLines.add("Where we met: $meetingEvent");
      }

      if (category != null && category.isNotEmpty) {
        noteLines.add("Category: $category");
      }

      newContact.notes = [
        Note(noteLines.join('\n\n'))
      ];

      // === Phones ===
      newContact.phones = phoneNumbers.map((phoneField) {
        final phoneType = phoneField.getPhoneType().toLowerCase();
        PhoneLabel label;
        switch (phoneType) {
          case 'mobile': label = PhoneLabel.mobile; break;
          case 'home': label = PhoneLabel.home; break;
          case 'work': label = PhoneLabel.work; break;
          case 'main': label = PhoneLabel.main; break;
          default: label = PhoneLabel.other;
        }
        return Phone(phoneField.getPhoneNumber(), label: label);
      }).toList();

      // === Emails ===
      newContact.emails = emails.map((emailField) {
        final emailType = emailField.getEmailType().toLowerCase();
        EmailLabel label;
        switch (emailType) {
          case 'personal': label = EmailLabel.home; break;
          case 'work': label = EmailLabel.work; break;
          default: label = EmailLabel.other;
        }
        return Email(emailField.getEmail(), label: label);
      }).toList();

      // === Addresses ===
      newContact.addresses = addresses.map((addressField) {
        final data = addressField.getAddressData();
        final addressType = data['type']?.toLowerCase() ?? 'home';
        AddressLabel label;
        switch (addressType) {
          case 'home': label = AddressLabel.home; break;
          case 'work': label = AddressLabel.work; break;
          default: label = AddressLabel.other;
        }

        final street = data['street'] ?? '';
        final city = data['city'] ?? '';
        final state = data['state'] ?? '';
        final zip = data['zip'] ?? '';
        final fullAddress = [street, city, state, zip].where((part) => part.isNotEmpty).join(', ');

        return Address(
          fullAddress,
          label: label,
          street: street,
          city: city,
          state: state,
          postalCode: zip,
        );
      }).toList();

      // === Profile photo ===
      if (profileImage != null) {
        final bytes = await profileImage.readAsBytes();
        newContact.photo = bytes;
      }

      // === Save to device ===
      await newContact.insert();

      debugPrint('Contact saved with timestamp: $formattedDateTime');

      return true;
    } catch (e) {
      debugPrint('Error saving contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving contact: ${e.toString()}'))
      );
      return false;
    }
  }

  static String? getSavedTimestamp(Contact contact) {
    final savedEvent = contact.events.firstWhere(
      (event) => event.customLabel.startsWith('Saved on:'),
      orElse: () => Event(year: 0, month: 0, day: 0),
    );
    return savedEvent.customLabel;
  }
}
