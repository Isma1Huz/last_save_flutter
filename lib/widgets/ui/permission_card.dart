import 'package:flutter/material.dart';
import 'package:last_save/utils/app_theme.dart';

/// PermissionCard displays a permission with allow button
class PermissionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool granted;
  final VoidCallback onRequest;

  const PermissionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.granted,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: granted ? null : onRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: granted ? Colors.grey[300] : AppTheme.primaryColor,
                minimumSize: const Size(100, 40),
              ),
              child: Text(granted ? 'Granted' : 'Allow'),
            ),
          ],
        ),
      ),
    );
  }
}
