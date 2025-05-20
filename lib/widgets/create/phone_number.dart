// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final List<String> phoneTypes = ['Mobile', 'Home', 'Work', 'Main', 'Other'];
  String selectedType = 'Mobile';

  PhoneNumberField({Key? key}) : super(key: key);

  String getPhoneNumber() {
    return controller.text;
  }

  String getPhoneType() {
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
              labelText: 'Phone number',
              labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
              border: const UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
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
            items: phoneTypes.map((String type) {
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

class PhoneNumbersWidget extends StatelessWidget {
  final List<PhoneNumberField> phoneNumbers;
  final VoidCallback onAddPhoneNumber;
  final Function(int) onRemovePhoneNumber;

  const PhoneNumbersWidget({
    Key? key,
    required this.phoneNumbers,
    required this.onAddPhoneNumber,
    required this.onRemovePhoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone numbers',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(phoneNumbers.length, (index) {
          return Column(
            children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: phoneNumbers[index]),
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: theme.iconTheme.color,
                      ),
                      onPressed: () => onRemovePhoneNumber(index),
                    ),
                  ],
              ),
              const SizedBox(height: 14),
            ],
          );
        }),
        TextButton.icon(
          onPressed: onAddPhoneNumber,
          icon: Icon(Icons.add, color: primaryColor),
          label: Text(
            'Add phone number',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
