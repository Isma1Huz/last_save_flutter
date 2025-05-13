// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

// Email Field Widget
class EmailField extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final List<String> emailTypes = ['Personal', 'Work', 'Other'];
  String selectedType = 'Personal';

  EmailField({Key? key}) : super(key: key);

  String getEmail() {
    return controller.text;
  }

  String getEmailType() {
    return selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Email address',
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
            ),
            value: selectedType,
            items: emailTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                selectedType = newValue;
              }
            },
          ),
        ),
      ],
    );
  }
}

// Emails Section Widget
class EmailsWidget extends StatelessWidget {
  final List<EmailField> emails;
  final VoidCallback onAddEmail;
  final Function(int) onRemoveEmail;

  const EmailsWidget({
    Key? key,
    required this.emails,
    required this.onAddEmail,
    required this.onRemoveEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email addresses',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        if (emails.isNotEmpty)
          ...List.generate(emails.length, (index) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: emails[index]),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => onRemoveEmail(index),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            );
          }),
        TextButton.icon(
          onPressed: onAddEmail,
          icon: const Icon(Icons.add, color: Color(0xFF00BCD4)),
          label: const Text(
            'Add email',
            style: TextStyle(color: Color(0xFF00BCD4)),
          ),
        ),
      ],
    );
  }
}