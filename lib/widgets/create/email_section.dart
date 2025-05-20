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
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              labelText: 'Email address',
              labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
              border: const UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
            value: selectedType,
            dropdownColor: theme.cardColor,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email addresses',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleMedium?.color,
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
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: theme.iconTheme.color,
                      ),
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
          icon: Icon(Icons.add, color: primaryColor),
          label: Text(
            'Add email',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
