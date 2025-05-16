import 'package:flutter/material.dart';
import 'package:no_noise/controller/local_video_cnotrol.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/view/widgets/videos/custom_sized_box_in_local_video.dart';
import 'package:no_noise/view/widgets/videos/custom_slider_duration_position.dart';
import 'package:no_noise/view/widgets/videos/skip_prevoius.dart';
import 'package:provider/provider.dart';

class LocalVideo extends StatelessWidget {
  const LocalVideo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context, listen: false);
    return Consumer<LocalVideoControl>(
      builder: (context, model, child) {
        if (model.isTranslate) {
          return Scaffold(
            backgroundColor: const Color(0xff202020),
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Scaffold(
            backgroundColor: const Color(0xff202020),
            body: SafeArea(
              child: Column(
                children: [
                  if (model.portrait(context) && !model.isTranslate)
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),

                  model.portrait(context)
                      ? CustomSizedBoxInLocalVideo(theme: theme, model: model)
                      : Expanded(
                        child: CustomSizedBoxInLocalVideo(
                          theme: theme,
                          model: model,
                        ),
                      ),
                  if (model.portrait(context))
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),

                  if (model.portrait(context) && model.isControlsVisible)
                    Column(
                      children: [
                        CustomSliderDurationPosition(model: model),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: SkipPrevoius(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
