import 'package:flutter/material.dart';

class RelationsCard extends StatelessWidget {
  const RelationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Relations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.blue[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Stack(
              children: [
                for (int i = 0; i < 20; i++)
                  Positioned(
                    left: (i * 7) % 120,
                    top: (i * 11) % 120,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.cyan[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
