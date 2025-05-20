import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/contact/contact_info_tile.dart';

class ContactMediaSection extends StatelessWidget {
  final Contact contact;

  const ContactMediaSection({
    Key? key,
    required this.contact,
  }) : super(key: key);

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
      child: ContactInfoTile(
        icon: Icons.photo_library,
        title: "Location ",
        subtitle: "",
        onTap: () {},
        iconColor: iconColor,
        textColor: textColor,
        subtitleColor: subtitleColor,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "0 >",
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        isLast: true,
      ),
    );
  }
}