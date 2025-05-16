import 'package:flutter/material.dart';
import 'package:no_noise/constant/texts.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/functions/validator.dart';
import 'package:no_noise/view/widgets/custom_design_buuton.dart';
import 'package:no_noise/view/widgets/custom_text_form_filed.dart'
    show CustomTextFormField;
import 'package:provider/provider.dart';

class CustomAlertDialogToAddVideos<T extends ChangeNotifier>
    extends StatelessWidget {
  const CustomAlertDialogToAddVideos({
    super.key,
    this.onTap,
    required this.isCreate,
    required this.model,
    this.altText,
  });
  final void Function()? onTap;
  final bool isCreate;
  final T model;
  final String? altText;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);

    return AlertDialog(
      backgroundColor: theme.primaryColor,
      content: Form(
        key: (model as dynamic).formState,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              label: altText ?? labelOfPlaylistName,
              controller: (model as dynamic).playlistName,
              validator: (p0) {
                return validator(p0!);
              },
            ),
            if (!isCreate)
              CustomTextFormField(
                label: labelOfLinkPlaylist,
                controller: (model as dynamic).playlistLink,
                validator: (p0) {
                  return validator(p0!);
                },
              ),
            CustomDesignBuuton(titleItem: "إضافة", onTap: onTap),
          ],
        ),
      ),
    );
  }
}
