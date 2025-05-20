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
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        TextFormField(
          textCapitalization: TextCapitalization.words,
          controller: firstNameController,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            labelText: 'First name',
            labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
            border: const UnderlineInputBorder(),
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
          textCapitalization: TextCapitalization.words,
          controller: lastNameController,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            labelText: 'Last name',
            labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
            border: const UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          textCapitalization: TextCapitalization.words,
          controller: companyController,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            labelText: 'Company',
            labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
            border: const UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
