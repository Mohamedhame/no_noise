import 'package:flutter/material.dart';
import 'package:no_noise/controller/local_video_cnotrol.dart';
import 'package:no_noise/view/widgets/videos/custom_duration_position.dart';

class CustomSliderDurationPosition extends StatelessWidget {
  const CustomSliderDurationPosition({super.key, required this.model});

  final LocalVideoControl model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                model.changePositionScreen(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: SizedBox(
                  width: 60,
                  height: 30,
                  child: Icon(Icons.screen_rotation, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Slider(
                  value: model.formatPosition(model.value),
                  max: model.controller!.value.duration.inSeconds.toDouble(),
                  onChanged: model.onChangedPosition,
                  activeColor: Colors.red,
                  inactiveColor: Colors.white54,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: CustomDurationPosition(),
        ),
      ],
    );
  }
}
