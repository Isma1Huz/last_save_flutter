import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/contact/contact_info_tile.dart';

class ContactPrivacySection extends StatelessWidget {
  final Contact contact;

  const ContactPrivacySection({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode 
        ? AppTheme.darkSurfaceColor 
        : Colors.white;
    final iconColor = isDarkMode 
        ? Colors.white70 
        : const Color(0xFF008069);
    final textColor = isDarkMode 
        ? AppTheme.darkTextColorPrimary 
        : AppTheme.darkTextColor;
    final subtitleColor = isDarkMode 
        ? AppTheme.darkTextColorSecondary 
        : AppTheme.lightTextColor;
    final redColor = isDarkMode 
        ? Colors.redAccent 
        : Colors.red;

    return Column(
      children: [
        
        const SizedBox(height: 8),
        
        // Block and report
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ContactInfoTile(
                icon: Icons.block,
                title: "Block ${contact.name}",
                subtitle: "",
                onTap: () {},
                iconColor: redColor,
                textColor: redColor,
                subtitleColor: subtitleColor,
              ),
              ContactInfoTile(
                icon: Icons.thumb_down,
                title: "Delete ${contact.name}",
                subtitle: "",
                onTap: () {},
                iconColor: redColor,
                textColor: redColor,
                subtitleColor: subtitleColor,
                isLast: true,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
      ],
    );
  }
}