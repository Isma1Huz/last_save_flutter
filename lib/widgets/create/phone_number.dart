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
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone numbers',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
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
                      icon: const Icon(Icons.remove_circle_outline),
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
          icon: const Icon(Icons.add, color: Color(0xFF00BCD4)),
          label: const Text(
            'Add phone number',
            style: TextStyle(color: Color(0xFF00BCD4)),
          ),
        ),
      ],
    );
  }
}