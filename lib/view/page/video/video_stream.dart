import 'package:flutter/material.dart';
import 'package:no_noise/controller/local_video_cnotrol.dart';
import 'package:no_noise/controller/onlin_video_control.dart';
import 'package:no_noise/controller/video_stream_ctrl.dart';
import 'package:no_noise/view/page/video/local_video.dart';
import 'package:no_noise/view/page/video/onlin_video.dart';
import 'package:provider/provider.dart';

class VideoStream extends StatelessWidget {
  const VideoStream({
    super.key,
    required this.video,
    required this.index,
    required this.title,
    required this.titleOfPlayList,
  });
  final List video;
  final int index;
  final String title;
  final String titleOfPlayList;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => VideoStreamCtrl(
            video: video,
            index: index,
            title: title,
            titleOfPlayList: titleOfPlayList,
          ),
      child: Consumer<VideoStreamCtrl>(
        builder: (context, model, child) {
          return StreamBuilder(
            stream: model.init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error occurred: ${snapshot.error}'),
                  ),
                );
              }
              if (snapshot.hasData && snapshot.data!) {
                return ChangeNotifierProvider(
                  create:
                      (context) => LocalVideoControl(
                        video: video,
                        index: index,
                        title: title,
                        pathFile: model.pathFile!,
                        titleOfPlayList: titleOfPlayList,
                      ),
                  builder: (context, child) {
                    return LocalVideo();
                  },
                );
              } else {
                return ChangeNotifierProvider(
                  create:
                      (context) => OnlinVideoControl(
                        video: video,
                        index: index,
                        title: title,
                        titleOfPlayList: titleOfPlayList,
                      ),
                  child: OnlinVideo(
                    video: video,
                    index: index,
                    titleOfPlayList: titleOfPlayList,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}