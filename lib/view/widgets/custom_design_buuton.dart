import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:provider/provider.dart';

class CustomDesignBuuton extends StatelessWidget {
  const CustomDesignBuuton({
    super.key,
    required this.titleItem,
    this.onTap,
    this.widget,
    this.fontSize = 18.0,
    this.fontWeight,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String titleItem;
  final void Function()? onTap;
  final Widget? widget;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(width: 0.5, color: theme.fontColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment:
                  widget == null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  titleItem,
                  style: GoogleFonts.amiri(
                    color: foregroundColor ?? theme.fontColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
                if (widget != null) widget!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
