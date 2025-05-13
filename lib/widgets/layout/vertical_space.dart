import 'package:flutter/material.dart';

/// A standard vertical spacing widget
class VerticalSpace extends StatelessWidget {
  final double height;

  const VerticalSpace({
    Key? key,
    this.height = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}


