import 'package:flutter/material.dart';

/// A divider with text in the middle
class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}


