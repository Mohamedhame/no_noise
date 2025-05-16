import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_noise/service/file_storage.dart';
import 'package:no_noise/view/page/video/video_stream.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:no_noise/functions/clean_title.dart';
import 'package:no_noise/service/shared.dart';

import 'abstract_video.dart';

class OnlinVideoControl extends AbstractVideo {
  OnlinVideoControl({
    required super.video,
    required super.index,
    required super.title,
    required super.titleOfPlayList,
  }) {
    WakelockPlus.enable();
    idx = index;
    notifyListeners();
    init(index);
    d = "${titleOfPlayList}_$index";
  }

  //=============
  YoutubePlayerController? controller;
  bool isLoading = true;
  String? d;
  TextEditingController textEditingController = TextEditingController();
  String? time;
  bool showForward = false;
  bool showRewind = false;
  double speed = 1.0;
  bool isGet = false;
  int? idx;

  init(int indx) {
    idx = indx;
    if (video.isEmpty || idx! >= video.length) return;

    String? videoUrl = video[indx]['videoUrl'];
    if (videoUrl == null) return;

    String? videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId == null) return;

    if (controller == null) {
      controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );

      late VoidCallback listener;
      listener = () {
        if (controller!.value.isReady &&
            controller!.metadata.duration != Duration.zero) {
          restorePlaybackPosition();
          controller!.removeListener(listener);
        }
      };

      controller!.addListener(listener);
    } else {
      controller!.load(videoId);
    }

    d = "${titleOfPlayList}_$indx";
    isLoading = false;
    notifyListeners();
  }

  @override
  void nextVideo(BuildContext context) async {
    if (idx! < video.length - 1) {
      int newIndex = idx! + 1;
      String cleanedTitle = cleanTitle(video, newIndex);
    bool isExit = await FileStorage.checkExist(
        dir: titleOfPlayList,
        fileName: cleanedTitle,
        format: "mp4",
      );
      if (isExit) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => VideoStream(
                  video: video,
                  index: newIndex,
                  title: cleanedTitle,
                  titleOfPlayList: titleOfPlayList,
                ),
          ),
        );
      } else {
        idx = newIndex;
        newVideo(idx!);
      }
    }
  }

  newVideo(int indx) {
    String? videoUrl = video[indx]['videoUrl'];
    if (videoUrl == null) return;
    String? videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId == null) return;

    controller?.load(videoId);
    d = "${titleOfPlayList}_$idx";
    idx = indx;
    notifyListeners();
  }

  @override
  void toggle() {
    if (controller!.value.isPlaying) {
      controller!.pause();
    } else {
      controller!.play();
    }
    notifyListeners();
  }

  @override
  void previous(BuildContext context) async {
    if (idx! > 0) {
      int newIndex = idx! - 1;
      String cleanedTitle = cleanTitle(video, newIndex);
     bool isExit = await FileStorage.checkExist(
        dir: titleOfPlayList,
        fileName: cleanedTitle,
        format: "mp4",
      );
      if (isExit) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => VideoStream(
                  video: video,
                  index: newIndex,
                  title: cleanedTitle,
                  titleOfPlayList: titleOfPlayList,
                ),
          ),
        );
      } else {
        idx = newIndex;
        newVideo(idx!);
      }
    }
  }

  @override
  void decreaseSpead() {
    if (speed > 0.5) {
      speed -= 0.05;
      controller!.setPlaybackRate(speed);
      notifyListeners();
    }
  }

  @override
  void increaseSpead() {
    if (speed < 2.0) {
      speed += 0.05;
      controller!.setPlaybackRate(speed);
      notifyListeners();
    }
  }

  @override
  void forward10() {
    controller!.seekTo(
      controller!.value.position + const Duration(seconds: 10),
    );
    showForward = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      showForward = false;
      notifyListeners();
    });
  }

  @override
  void rewind10() {
    controller!.seekTo(
      controller!.value.position - const Duration(seconds: 10),
    );
    showRewind = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      showRewind = false;
      notifyListeners();
    });
  }

  @override
  getNotes() async {
    final Duration position = controller!.value.position;
    final minutes = position.inMinutes;
    final seconds = position.inSeconds % 60;
    String? data = await Shared.getNotes(d!);
    time = "$minutes:${seconds.toString().padLeft(2, '0')}";
    if (data != null) {
      textEditingController.text = "$data\n${time!}:";
    } else {
      textEditingController.text = "${time!}:";
    }
    notifyListeners();
  }

  @override
  bool portrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
    WakelockPlus.disable();
    savePlaybackPosition();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void selectOfSpeedFromSlider(double value) {
    speed = value;
    controller!.setPlaybackRate(speed);
    notifyListeners();
  }

  @override
  void savePlaybackPosition() {
    final Duration position = controller!.value.position;
    Duration videoDuration = controller!.metadata.duration;
    Shared.setPrecentVideo(
      super.title,
      position.inSeconds / videoDuration.inSeconds,
    );
  }

  @override
  void restorePlaybackPosition() async {
    double percent = await Shared.getPrecentVideo(super.title);

    if (percent == 0) {
      return;
    }
    if (controller!.metadata.duration.inSeconds == 0) {
      return;
    }
    int pos = (percent * controller!.metadata.duration.inSeconds).toInt();
    controller!.seekTo(Duration(seconds: pos));
  }

  changeIsGet() async {
    isGet = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 2), () {
      isGet = false;
      notifyListeners();
    });
  }
}
