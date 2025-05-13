import 'package:flutter/material.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/onboarding/page_indicator.dart';
import 'package:last_save/widgets/ui/permission_card.dart';

class PermissionsPage extends StatelessWidget {
  final List<Map<String, dynamic>> permissions;
  final int currentPage;
  final int totalPages;
  final Function(int) onRequestPermission;
  final VoidCallback onContinue;

  const PermissionsPage({
    super.key,
    required this.permissions,
    required this.currentPage,
    required this.totalPages,
    required this.onRequestPermission,
    required this.onContinue,
  });

  bool get allPermissionsGranted => 
      permissions.every((p) => p['granted'] == true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Permissions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'LastSave needs the following permissions to provide you with the best experience:',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: permissions.length,
              itemBuilder: (context, index) {
                final permission = permissions[index];
                return PermissionCard(
                  title: permission['title'],
                  description: permission['description'],
                  icon: permission['icon'],
                  granted: permission['granted'],
                  onRequest: () => onRequestPermission(index),
                );
              },
            ),
          ),
          PageIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              child: ElevatedButton(
                onPressed: allPermissionsGranted ? onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text(
                  'Finish up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
