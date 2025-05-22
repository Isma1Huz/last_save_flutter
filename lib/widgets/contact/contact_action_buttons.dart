import 'package:flutter/material.dart';

class ContactActionButtons extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onEmail;

  const ContactActionButtons({
    super.key,
    required this.onCall,
    required this.onMessage,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.call,
          label: 'Call',
          onTap: onCall,
          textColor: textColor,
        ),
        _buildActionButton(
          icon: Icons.message,
          label: 'Message',
          onTap: onMessage,
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 26,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}