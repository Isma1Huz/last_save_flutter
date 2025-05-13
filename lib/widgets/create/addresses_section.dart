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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: 'Street address',
                  border: UnderlineInputBorder(),
                ),
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
          decoration: const InputDecoration(
            labelText: 'City',
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: stateController,
                decoration: const InputDecoration(
                  labelText: 'State/Province',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: zipController,
                decoration: const InputDecoration(
                  labelText: 'ZIP/Postal code',
                  border: UnderlineInputBorder(),
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

// Addresses Section Widget
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Addresses',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
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
                        icon: const Icon(Icons.remove_circle_outline),
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
          icon: const Icon(Icons.add, color: Color(0xFF00BCD4)),
          label: const Text(
            'Add address',
            style: TextStyle(color: Color(0xFF00BCD4)),
          ),
        ),
      ],
    );
  }
}