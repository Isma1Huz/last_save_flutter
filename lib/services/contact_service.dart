import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:last_save/widgets/create/addresses_section.dart';
import 'package:last_save/widgets/create/email_section.dart';
import 'package:last_save/widgets/create/phone_number.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

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
      // Request contacts permission
      if (!await FlutterContacts.requestPermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contacts permission denied'))
        );
        return false;
      }
      
      // Create a new contact
      final newContact = Contact();
      
      // Set name
      newContact.name.first = firstName;
      newContact.name.last = lastName;
      
      // Set company
      if (company.isNotEmpty) {
        newContact.organizations = [
          Organization(company: company)
        ];
      }
      
      // Get current date and time
      final now = DateTime.now();
      final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      
      // Add timestamp as an event with a special label
      newContact.events = [
        Event(
          year:  now.year, 
          month: now.month, 
          day: now.day,
          label: EventLabel.other,
          // Use the custom label to indicate this is our saved timestamp
          customLabel: "Saved on: $formattedDateTime"
        )
      ];
      
      // Set notes
      if ((notes != null && notes.isNotEmpty) || 
          (meetingEvent != null && meetingEvent.isNotEmpty) || 
          (category != null)) {
        String noteText = notes ?? '';
        
        // Add meeting event info to notes if available
        if (meetingEvent != null && meetingEvent.isNotEmpty) {
          noteText += '\n\nWhere we met: $meetingEvent';
        }
        
        // Add category to notes if available
        if (category != null) {
          noteText += '\n\nCategory: $category';
        }
        
        newContact.notes = [Note(noteText)];
      }
      
      // Set phone numbers
      newContact.phones = phoneNumbers.map((phoneField) {
        final phoneType = phoneField.getPhoneType().toLowerCase();
        PhoneLabel label;
        
        switch (phoneType) {
          case 'mobile':
            label = PhoneLabel.mobile;
            break;
          case 'home':
            label = PhoneLabel.home;
            break;
          case 'work':
            label = PhoneLabel.work;
            break;
          case 'main':
            label = PhoneLabel.main;
            break;
          default:
            label = PhoneLabel.other;
        }
        
        return Phone(phoneField.getPhoneNumber(), label: label);
      }).toList();
      
      // Set emails
      newContact.emails = emails.map((emailField) {
        final emailType = emailField.getEmailType().toLowerCase();
        EmailLabel label;
        
        switch (emailType) {
          case 'personal':
            label = EmailLabel.home;
            break;
          case 'work':
            label = EmailLabel.work;
            break;
          default:
            label = EmailLabel.other;
        }
        
        return Email(emailField.getEmail(), label: label);
      }).toList();
      
      // Set addresses
      newContact.addresses = addresses.map<Address>((addressField) {
        final data = addressField.getAddressData();
        final addressType = data['type']?.toLowerCase() ?? 'home';
        AddressLabel label;
        
        switch (addressType) {
          case 'home':
            label = AddressLabel.home;
            break;
          case 'work':
            label = AddressLabel.work;
            break;
          default:
            label = AddressLabel.other;
        }
        
        // Create the full address string for the required positional parameter
        final street = data['street'] ?? '';
        final city = data['city'] ?? '';
        final state = data['state'] ?? '';
        final zip = data['zip'] ?? '';
        
        final fullAddress = [street, city, state, zip]
            .where((part) => part.isNotEmpty)
            .join(', ');
        
        // The Address constructor requires a positional parameter for the full address
        return Address(
          fullAddress,  // Required positional parameter
          label: label,
          street: street,
          city: city,
          state: state,
          postalCode: zip,
        );
      }).toList();
      
      // Set photo
      if (profileImage != null) {
        final bytes = await profileImage.readAsBytes();
        newContact.photo = bytes;
      }
      
      // Save contact to device
      await newContact.insert();
      
      return true;
    } catch (e) {
      debugPrint('Error saving contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving contact: ${e.toString()}'))
      );
      return false;
    }
  }
  
  // Helper method to retrieve the saved timestamp from a contact
  static String? getSavedTimestamp(Contact contact) {
    final savedEvent = contact.events.firstWhere(
      (event) => event.customLabel?.startsWith('Saved on:') ?? false,
      orElse: () => Event(year: 0, month: 0, day: 0),
    );
    
    return savedEvent.customLabel;
  }
}