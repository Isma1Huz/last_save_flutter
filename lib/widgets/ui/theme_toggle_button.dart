import 'package:flutter/material.dart';
import 'package:last_save/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode 
            ? Icons.light_mode 
            : Icons.dark_mode,
      ),
      onPressed: () {
        themeProvider.toggleTheme();
      },
      tooltip: themeProvider.isDarkMode 
          ? 'Switch to light mode' 
          : 'Switch to dark mode',
    );
  }
}
