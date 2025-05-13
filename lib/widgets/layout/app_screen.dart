import 'package:flutter/material.dart';

// A standard screen layout with consistent padding and scroll behavior
class AppScreen extends StatefulWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  final Widget? bottomNavigationBar;
  final bool extendBodyBehindAppBar;

  const AppScreen({
    Key? key,
    required this.child,
    this.appBar,
    this.padding = const EdgeInsets.all(24.0),
    this.scrollable = true,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
  }) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      bottomNavigationBar: widget.bottomNavigationBar,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      body: widget.scrollable
          ? SingleChildScrollView(
              padding: widget.padding,
              child: widget.child,
            )
          : Padding(
              padding: widget.padding,
              child: widget.child,
            ),
    );
  }
}


