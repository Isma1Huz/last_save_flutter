import 'package:flutter/material.dart';

class NotesWidget extends StatelessWidget {
  final TextEditingController notesController;

  const NotesWidget({
    Key? key,
    required this.notesController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags & notes',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          // padding: const EdgeInsets.all(16),
          child: TextFormField(
            controller: notesController,
            decoration: const InputDecoration(
              hintText: 'Add notes',
              border: InputBorder.none,
            ),
            maxLines: 5,
          ),
        ),
      ],
    );
  }
}