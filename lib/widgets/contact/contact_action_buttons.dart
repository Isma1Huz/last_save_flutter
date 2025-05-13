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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.call, 'Call', Colors.green, onCall),
          _buildActionButton(Icons.message, 'Message', Colors.blue, onMessage),
          _buildActionButton(Icons.videocam, 'Video', Colors.purple, onVideo),
          _buildActionButton(Icons.email, 'Email', Colors.red, onEmail),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
