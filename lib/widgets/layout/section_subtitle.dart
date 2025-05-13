import 'package:flutter/material.dart';

/// A section subtitle with consistent styling
class SectionSubtitle extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const SectionSubtitle({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
      ),
    );
  }
}

