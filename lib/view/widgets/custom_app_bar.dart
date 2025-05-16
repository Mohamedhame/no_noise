import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/controller/theme_controller.dart';

AppBar customAppBar({
  required ThemeController theme,
  required String title,
  Widget? widget,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    foregroundColor: theme.fontColor,
    title: Text(
      title,
      style: GoogleFonts.amiri(
        color: theme.fontColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
    actions: [if (widget != null) widget],
  );
}
