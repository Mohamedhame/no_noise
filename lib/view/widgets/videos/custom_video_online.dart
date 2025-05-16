import 'package:flutter/material.dart';
import 'package:no_noise/controller/onlin_video_control.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/view/widgets/videos/custom_notes.dart';
import 'package:no_noise/view/widgets/videos/custom_speed_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomVideo extends StatelessWidget {
  const CustomVideo({
    super.key,
    required this.youtubePlayerController,
    required this.isPortrait,
    required this.title,
    this.nextVideo,
    this.previousVideo,
    required this.them,
  });

  final YoutubePlayerController youtubePlayerController;
  final bool isPortrait;
  final String title;
  final void Function()? nextVideo;
  final void Function()? previousVideo;
  final ThemeController them;

  @override
  Widget build(BuildContext context) {
    return Consumer<OnlinVideoControl>(
      builder: (context, model, child) {
        return YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: youtubePlayerController,

            topActions: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 9 / 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        model.nextVideo(context);
                      },
                      icon: Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        model.previous(context);
                      },
                      icon: Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            bottomActions: [
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  model.changePositionScreen(context);
                },
                icon: Icon(Icons.screen_rotation, color: Colors.white),
              ),
              CurrentPosition(),
              ProgressBar(isExpanded: true),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showBottomSheet(
                      backgroundColor: const Color.fromARGB(255, 71, 69, 69),
                      context: context,
                      builder: (context) {
                        return CustomSpeedBottomSheet(
                          model: model,
                          // theme: them,
                        );
                      },
                    );
                  },
                  child:
                      model.speed == 1.0
                          ? Icon(Icons.speed, color: Colors.white)
                          : DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${model.speed.toStringAsFixed(2)}x',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                ),
              ),
              RemainingDuration(),
            ],
          ),
          builder: (context, player) {
            return Stack(
              children: [
                GestureDetector(
                  onDoubleTapDown: (details) {
                    final width = MediaQuery.of(context).size.width;
                    final dx = details.globalPosition.dx;
                    if (dx < width / 2) {
                      model.rewind10();
                    } else {
                      model.forward10();
                    }
                  },
                  child: player,
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
                            textEditingController: model.textEditingController,
                            title: model.d!,
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
              ],
            );
          },
        );
      },
    );
  }
}
