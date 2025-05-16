import 'package:flutter/material.dart';
import 'package:no_noise/controller/local_video_cnotrol.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/view/widgets/videos/custom_bottom_sheet.dart';
import 'package:no_noise/view/widgets/videos/custom_text_duratuin_position.dart';
import 'package:provider/provider.dart';


class CustomDurationPosition extends StatelessWidget {
  const CustomDurationPosition({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context, listen: false);
    return Consumer<LocalVideoControl>(
      builder: (context, model, child) {
        return Row(
          children: [
            Expanded(
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextDurationPosition(
                    text: model.formatDuration(model.duration),
                  ),
                  CustomTextDurationPosition(
                    text: model.formatDuration(model.position),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 25,
              width: 30,
              child: CustomShowBottomSheet(theme: theme, model: model),
            ),
          ],
        );
      },
    );
  }
}




