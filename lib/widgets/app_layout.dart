import 'package:flutter/material.dart';

/// A standard screen layout with consistent padding and scroll behavior
class AppScreen extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  final Widget? bottomNavigationBar;

  const AppScreen({
    Key? key,
    required this.child,
    this.appBar,
    this.padding = const EdgeInsets.all(24.0),
    this.scrollable = true,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: scrollable
            ? SingleChildScrollView(
                padding: padding,
                child: child,
              )
            : Padding(
                padding: padding,
                child: child,
              ),
      ),
    );
  }
}

/// A section title with consistent styling
class SectionTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;

  const SectionTitle({
    Key? key,
    required this.title,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

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