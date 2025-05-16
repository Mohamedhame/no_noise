import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:provider/provider.dart';

class CustomTextDeleteButton extends StatelessWidget {
  const CustomTextDeleteButton({
    super.key,
    this.onTap,
    required this.titleButton,
  });

  final String titleButton;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
     final ThemeController theme = Provider.of<ThemeController>(context);
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.fontColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textAlign: TextAlign.center,
            titleButton,
            style: GoogleFonts.amiri(color: theme.primaryColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
