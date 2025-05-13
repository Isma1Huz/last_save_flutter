import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/utils/app_theme.dart';

class ContactHeader extends StatelessWidget {
  final Contact contact;

  const ContactHeader({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withOpacity(0.2),
            ),
            child: contact.photo != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.memory(
                      contact.photo!,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  )
                : Center(
                    child: Text(
                      contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            contact.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (contact.categories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Wrap(
                spacing: 4,
                children: contact.categories.map((categoryId) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      categoryId == '1' ? 'Recently saved' : 'Business',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
