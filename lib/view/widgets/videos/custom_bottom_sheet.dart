import 'package:flutter/material.dart';
import 'package:no_noise/controller/local_video_cnotrol.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/view/widgets/videos/custom_speed_bottom_sheet.dart';

class CustomShowBottomSheet extends StatelessWidget {
  const CustomShowBottomSheet({
    super.key,
    required this.theme,
    required this.model,
  });

  final ThemeController theme;
  final LocalVideoControl model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showBottomSheet(
          backgroundColor: const Color.fromARGB(255, 71, 69, 69),
          context: context,
          builder: (context) {
            return CustomSpeedBottomSheet(model: model);
          },
        );
      },
      child:
          model.speed == 1.0
              ? Icon(Icons.speed, color: Colors.white)
              : Text(
                '${model.speed}x',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
    );
  }
}