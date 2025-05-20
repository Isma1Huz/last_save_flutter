import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/contact/contact_info_tile.dart';

class ContactInfoSection extends StatelessWidget {
  final Contact contact;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onEmail;

  const ContactInfoSection({
    super.key,
    required this.contact,
    required this.onCall,
    required this.onMessage,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    final cardColor = isDarkMode 
        ? AppTheme.darkSurfaceColor 
        : Colors.white;
    final iconColor = isDarkMode 
        ? Colors.white70 
        : theme.primaryColor;
    final textColor = isDarkMode 
        ? AppTheme.darkTextColorPrimary 
        : AppTheme.darkTextColor;
    final subtitleColor = isDarkMode 
        ? AppTheme.darkTextColorSecondary 
        : AppTheme.lightTextColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [          
          // Phone number
          ContactInfoTile(
            icon: Icons.call,
            title: contact.phoneNumber,
            subtitle: "Mobile",
            onTap: onCall,
            iconColor: iconColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.message,
                    color: iconColor,
                    size: 22,
                  ),
                  onPressed: onMessage,
                ),
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: iconColor,
                    size: 22,
                  ),
                  onPressed: onCall,
                ),
              ],
            ),
          ),
          
          // Email if available
          if (contact.email != null && contact.email!.isNotEmpty)
            ContactInfoTile(
              icon: Icons.email,
              title: contact.email!,
              subtitle: "Email",
              onTap: onEmail,
              iconColor: iconColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              trailing: IconButton(
                icon: Icon(
                  Icons.email,
                  color: iconColor,
                  size: 22,
                ),
                onPressed: onEmail,
              ),
              isLast: true,
            ),
        ],
      ),
    );
  }
}