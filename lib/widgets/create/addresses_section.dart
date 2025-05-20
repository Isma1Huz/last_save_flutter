// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

// Address Field Widget
class AddressField extends StatelessWidget {
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final List<String> addressTypes = ['Home', 'Work', 'Other'];
  String selectedType = 'Home';

  AddressField({Key? key}) : super(key: key);

  Map<String, String> getAddressData() {
    return {
      'street': streetController.text,
      'city': cityController.text,
      'state': stateController.text,
      'zip': zipController.text,
      'type': selectedType,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: streetController,
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  labelText: 'Street address',
                  labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  border: const UnderlineInputBorder(),
                ),
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
                items: addressTypes.map((String type) {
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
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: cityController,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            labelText: 'City',
            labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
            border: const UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: stateController,
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  labelText: 'State/Province',
                  labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  border: const UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: zipController,
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  labelText: 'ZIP/Postal code',
                  labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  border: const UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Addresses Section
class AddressesWidget extends StatelessWidget {
  final List<AddressField> addresses;
  final VoidCallback onAddAddress;
  final Function(int) onRemoveAddress;

  const AddressesWidget({
    Key? key,
    required this.addresses,
    required this.onAddAddress,
    required this.onRemoveAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Addresses',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 8),
        if (addresses.isNotEmpty)
          ...List.generate(addresses.length, (index) {
            return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: addresses[index]),
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: theme.iconTheme.color,
                        ),
                        onPressed: () => onRemoveAddress(index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14)
                ],
              );
          }),
        TextButton.icon(
          onPressed: onAddAddress,
          icon: Icon(Icons.add, color: primaryColor),
          label: Text(
            'Add address',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
