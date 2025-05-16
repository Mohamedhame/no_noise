import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:provider/provider.dart';

class CustomErrorAlert extends StatelessWidget {
  const CustomErrorAlert({super.key, required this.messageError});
  final String messageError;

  @override
  Widget build(BuildContext context) {
    final ThemeController theme = Provider.of<ThemeController>(context);
    return AlertDialog(
      backgroundColor: theme.fontColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              "خطأ",
              style: GoogleFonts.amiri(color: theme.primaryColor),
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            messageError,
            style: GoogleFonts.amiri(
              color: theme.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
