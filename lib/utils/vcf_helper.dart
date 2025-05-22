import 'dart:io';
import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:share_plus/share_plus.dart';

class VcfHelper {
  /// Creates a VCF file from a contact and returns the file path
  static Future<String> createVcfFile(Contact contact) async {
    // Create vCard content
    final vCard = createVCardString(contact);
    
    // Get temporary directory to save the vCard file
    final directory = await path_provider.getTemporaryDirectory();
    final fileName = '${contact.name.replaceAll(' ', '_')}.vcf';
    final filePath = '${directory.path}/$fileName';
    
    // Write vCard content to file
    final file = File(filePath);
    await file.writeAsString(vCard);
    
    return filePath;
  }

  /// Creates a simplified VCF string from a contact (more compatible with WhatsApp)
  static String createVCardString(Contact contact) {
    // Build a simplified vCard 2.1 format (more widely compatible)
    final buffer = StringBuffer();
    
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:2.1');
    
    // Name - simplified format
    final escapedName = escapeVCardValue(contact.name);
    buffer.writeln('FN:$escapedName');
    
    // Split name into parts if possible
    final nameParts = contact.name.split(' ');
    if (nameParts.length > 1) {
      final lastName = escapeVCardValue(nameParts.last);
      final firstName = escapeVCardValue(nameParts.take(nameParts.length - 1).join(' '));
      buffer.writeln('N:$lastName;$firstName;;;');
    } else {
      buffer.writeln('N:$escapedName;;;;');
    }
    
    // Phone - ensure it's properly formatted (only include digits and +)
    if (contact.phoneNumber.isNotEmpty) {
      final cleanPhone = contact.phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      buffer.writeln('TEL;CELL:$cleanPhone');
    }
    
    // Email - simplified format
    if (contact.email != null && contact.email!.isNotEmpty) {
      buffer.writeln('EMAIL:${escapeVCardValue(contact.email!)}');
    }
    
    // End vCard
    buffer.writeln('END:VCARD');
    
    return buffer.toString();
  }

  /// Escapes special characters in vCard values
  static String escapeVCardValue(String value) {
    return value
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll('\n', '\\n');
  }

  /// Shares a contact as a VCF file
  static Future<void> shareContact(BuildContext context, Contact contact) async {
    try {
      // Create VCF file
      final filePath = await createVcfFile(contact);
      
      // Log for debugging
      debugPrint('VCF file created at: $filePath');
      debugPrint('VCF content: ${await File(filePath).readAsString()}');
      
      // Share the file directly without text
      await Share.shareXFiles(
        [XFile(filePath, mimeType: 'text/x-vcard')],
      );
    } catch (e) {
      debugPrint('Error sharing contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing contact: $e')),
      );
    }
  }
}
