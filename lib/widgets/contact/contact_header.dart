import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';

class ContactHeader extends StatelessWidget {
  final Contact contact;

  const ContactHeader({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode 
                  ? Colors.grey.shade800 
                  : Colors.white.withOpacity(0.2),
            ),
            child: contact.photo != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.memory(
                      contact.photo!,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  )
                : Center(
                    child: Text(
                      contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            contact.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
                  
        ],
      ),
    );
  }
}