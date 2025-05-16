import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/functions/opacity_to_alph.dart';
import 'package:no_noise/view/widgets/custom_design_buuton.dart';

class CustomAddPlaylist extends StatelessWidget {
  const CustomAddPlaylist({
    super.key,
    required this.theme,
    this.onTap,
    required this.text,
    this.create,
    required this.isOnlyVideo,
  });

  final ThemeController theme;
  final void Function()? onTap;
  final void Function()? create;
  final String text;
  final bool isOnlyVideo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.fontColor.withAlpha(opacityToAlpha(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  text,
                  style: GoogleFonts.amiri(
                    color: theme.fontColor,
                    fontSize: 20,
                  ),
                ),
                CustomDesignBuuton(
                  titleItem: "إضافة",
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.fontColor,
                  onTap: onTap,
                ),
                if (!isOnlyVideo)
                  CustomDesignBuuton(
                    titleItem: "إنشاء قائمة تشغيل خاصة بك",
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.fontColor,
                    onTap: create,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
