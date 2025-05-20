import 'package:flutter/material.dart';

class ContactActionButtons extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onVideo;
  final VoidCallback onEmail;

  const ContactActionButtons({
    super.key,
    required this.onCall,
    required this.onMessage,
    required this.onVideo,
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
          label: 'Audio',
          onTap: onCall,
          textColor: textColor,
        ),
        _buildActionButton(
          icon: Icons.videocam,
          label: 'Video',
          onTap: onVideo,
          textColor: textColor,
        ),
        _buildActionButton(
          icon: Icons.message,
          label: 'Message',
          onTap: onMessage,
          textColor: textColor,
        ),
        _buildActionButton(
          icon: Icons.currency_rupee,
          label: 'Pay',
          onTap: () {},
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