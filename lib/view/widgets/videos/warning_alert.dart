import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/view/widgets/custom_delete_button.dart';
import 'package:provider/provider.dart';

class WarningAlert extends StatelessWidget {
  const WarningAlert({
    super.key,
    required this.warningTitle,
    required this.warningBody,
    this.finalDelete,
    this.deleteFromApp,
  });
  final String warningTitle;
  final String warningBody;
  final void Function()? finalDelete;
  final void Function()? deleteFromApp;

  @override
  Widget build(BuildContext context) {
    final ThemeController theme = Provider.of<ThemeController>(context);
    return AlertDialog(
      backgroundColor: theme.primaryColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              warningTitle,
              style: GoogleFonts.amiri(color: theme.fontColor, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              warningBody,
              style: GoogleFonts.amiri(color: theme.fontColor, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextDeleteButton(
                  titleButton: "حذف نهائيا",
                  onTap: finalDelete,
                ),
                const SizedBox(width: 10),
                CustomTextDeleteButton(
                  titleButton: "حذف من التطبيق فقط",
                  onTap: deleteFromApp,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            child: CustomTextDeleteButton(
              titleButton: "إلغاء",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
