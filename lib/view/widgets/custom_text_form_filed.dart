import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:provider/provider.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.label,
    this.suffixIcon,
    this.onChanged,
    this.readOnly = false,
    this.controller,
    this.isNumber,
    this.validator,
  });
  final String? label;
  final void Function(String)? onChanged;
  final bool readOnly;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool? isNumber;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validator,
        style: GoogleFonts.amiri(color: theme.fontColor),
        keyboardType:
            isNumber != null ? TextInputType.numberWithOptions() : null,
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          label: Text(
            label ?? "",
            style: GoogleFonts.amiri(color: theme.fontColor),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
