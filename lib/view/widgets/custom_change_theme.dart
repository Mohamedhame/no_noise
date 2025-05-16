import 'package:flutter/material.dart';
import 'package:no_noise/controller/theme_controller.dart';

class CustomChangeTheme extends StatelessWidget {
  const CustomChangeTheme({
    super.key,
    required this.theme,
  });

  final ThemeController theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: InkWell(
          onTap: () {
            theme.toggleTheme();
          },
          child: Icon(
            theme.isLight ? Icons.light_mode : Icons.dark_mode,
            color: theme.fontColor,
          ),
        ),
      ),
    );
  }
}