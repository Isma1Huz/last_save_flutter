import 'package:flutter/material.dart';

class BasicInfoWidget extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController companyController;

  const BasicInfoWidget({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.companyController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        TextFormField(
          controller: firstNameController,
          decoration: const InputDecoration(
            labelText: 'First name',
            border: UnderlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a first name';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: lastNameController,
          decoration: const InputDecoration(
            labelText: 'Last name',
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: companyController,
          decoration: const InputDecoration(
            labelText: 'Company',
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}