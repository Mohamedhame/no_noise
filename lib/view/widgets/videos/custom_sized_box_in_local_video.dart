import 'package:flutter/material.dart';
import 'package:no_noise/controller/local_video_cnotrol.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/view/widgets/videos/custom_notes.dart';
import 'package:no_noise/view/widgets/videos/custom_slider_duration_position.dart';
import 'package:no_noise/view/widgets/videos/skip_prevoius.dart';
import 'package:video_player/video_player.dart';

class CustomSizedBoxInLocalVideo extends StatelessWidget {
  const CustomSizedBoxInLocalVideo({
    super.key,
    required this.theme,
    required this.model,
  });

  final ThemeController theme;
  final LocalVideoControl model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: model.controller!.value.aspectRatio,
        child: Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
              child: Opacity(
                opacity: model.isControlsVisible ? 0.6 : 1,
                child: GestureDetector(
                  onTap: () => model.hideApperWidgetsInFrontVideo(),
                  onDoubleTapDown: (details) {
                    final width = MediaQuery.of(context).size.width;
                    final dx = details.globalPosition.dx;

                    if (dx < width / 2) {
                      model.forward10();
                    } else {
                      model.rewind10();
                    }
                  },
                  child: VideoPlayer(model.controller!),
                ),
              ),
            ),

            Positioned(
              top: 5,
              right: 15,
              child: InkWell(
                onTap: () async {
                  await model.getNotes();
                  showBottomSheet(
                    backgroundColor: const Color.fromARGB(255, 71, 69, 69),
                    context: context,
                    builder: (context) {
                      return CustomNotes(
                        isPortrait: model.portrait(context),
                        textEditingController: model.notesController,
                        title: model.newTitle,
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.note_add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),

            if (model.showRewind)
              Positioned(
                left: 30,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Icon(
                    Icons.fast_rewind,
                    size: 60,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),

            if (model.showForward)
              Positioned(
                right: 30,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Icon(
                    Icons.fast_forward,
                    size: 60,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            if (!model.portrait(context) && model.isControlsVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomSliderDurationPosition(model: model),
              ),
            if (!model.portrait(context) && model.isControlsVisible)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: SkipPrevoius(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}