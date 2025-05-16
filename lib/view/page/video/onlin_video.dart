import 'package:flutter/material.dart';
import 'package:no_noise/controller/onlin_video_control.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/view/widgets/videos/custom_video_online.dart';
import 'package:provider/provider.dart';

class OnlinVideo extends StatelessWidget {
  const OnlinVideo({
    super.key,
    required this.video,
    required this.index,
    this.title,
    required this.titleOfPlayList,
  });
  final List video;
  final int index;
  final String? title;
  final String titleOfPlayList;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context, listen: false);
    return Consumer<OnlinVideoControl>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color(0xff202020),
          body: SafeArea(
            child:
                model.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomVideo(
                          youtubePlayerController: model.controller!,
                          isPortrait: model.portrait(context),
                          title: model.d!,
                          them: theme,
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }
}
