import 'dart:io';
import 'package:flutter/material.dart';
import 'package:no_noise/view/page/video/video_stream.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:no_noise/controller/abstract_video.dart';
import 'package:no_noise/functions/clean_title.dart';
import 'package:no_noise/service/file_storage.dart';
import 'package:no_noise/service/shared.dart';

class LocalVideoControl extends AbstractVideo {
  LocalVideoControl({
    required super.video,
    required super.index,
    required super.title,
    required super.titleOfPlayList,
    required this.pathFile,
  }) {
    WakelockPlus.enable();
    idx = index;
    init(pathFile);
    restorePlaybackPosition();
  }

  final String pathFile;
  VideoPlayerController? controller;
  int? idx;
  bool isControlsVisible = false;
  double speed = 1.0;

  String newTitle = "";
  bool showRewind = false;
  bool showForward = false;
  bool isTranslate = false;
  TextEditingController notesController = TextEditingController();

  Duration get position => controller?.value.position ?? Duration.zero;
  Duration get duration => controller?.value.duration ?? Duration.zero;
  Duration get value => controller?.value.position ?? Duration.zero;
  bool get isPlaying => controller?.value.isPlaying ?? false;
  bool get isInitialized => controller?.value.isInitialized ?? false;

  Future<void> init(String path) async {
    if (File(pathFile).existsSync()) {
      _initializeVideo(path);
      controller?.addListener(_onPositionChange);
      // notifyListeners();
    } else {
      print("File not found: $path");
    }
  }

  void _initializeVideo(String path) {
    if (controller != null) {
      controller!.dispose();
    }
    controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        if (controller!.value.isInitialized) {
          controller!.play();
        }
      });
  }

  void _onPositionChange() => notifyListeners();

  void hideApperWidgetsInFrontVideo() {
    isControlsVisible = !isControlsVisible;
    if (controller!.value.isPlaying) {
      Future.delayed(Duration(seconds: 10), () {
        isControlsVisible = false;
      });
    }
    notifyListeners();
  }

  void onChangedPosition(double v) =>
      controller!.seekTo(Duration(seconds: v.toInt()));

  @override
  void forward10() {
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
  void rewind10() {
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
  getNotes() async {
    final Duration posit = position;
    final minutes = posit.inMinutes;
    final seconds = posit.inSeconds % 60;
    newTitle = "${titleOfPlayList}_$idx";
    notifyListeners();
    String? data = await Shared.getNotes(newTitle);
    String time = "$minutes:${seconds.toString().padLeft(2, '0')}";
    if (data != null) {
      notesController.text = "$data\n$time:";
      notifyListeners();
    } else {
      notesController.text = "$time:";
      notifyListeners();
    }
  }

  @override
  void savePlaybackPosition() {
    Shared.setPrecentVideo(
      super.title,
      position.inSeconds / duration.inSeconds,
    );
  }

  @override
  void increaseSpead() {
    if (speed < 2.0) {
      speed += 0.05;
      controller!.setPlaybackSpeed(speed);
    }
  }

  @override
  void decreaseSpead() {
    if (speed > 0.5) {
      speed -= 0.05;
      controller!.setPlaybackSpeed(speed);
    }
  }

  @override
  void nextVideo(BuildContext context) async {
    isTranslate = true;
    notifyListeners();
    if (idx! < video.length - 1) {
      int newIndex = idx! + 1;
      String cleanedTitle = cleanTitle(video, newIndex);
      bool isExit = await FileStorage.checkExist(
        dir: titleOfPlayList,
        fileName: cleanedTitle,
        format: "mp4",
      );

      if (isExit) {
        newVideo(newIndex, cleanedTitle);
      } else {
        controller!.dispose();
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
      }
    }
    Future.delayed(Duration(milliseconds: 300), () {
      isTranslate = false;
      notifyListeners();
    });
  }

  @override
  bool portrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  @override
  void previous(BuildContext context) async {
    isTranslate = true;
    notifyListeners();
    if (idx! > 0) {
      int newIndex = idx! - 1;
      String cleanedTitle = cleanTitle(video, newIndex);
      bool isExit = await FileStorage.checkExist(
        dir: titleOfPlayList,
        fileName: cleanedTitle,
        format: "mp4",
      );
      if (isExit) {
        newVideo(newIndex, cleanedTitle);
      } else {
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
      }
    }
    Future.delayed(Duration(milliseconds: 300), () {
      isTranslate = false;
      notifyListeners();
    });
  }

  @override
  void selectOfSpeedFromSlider(double value) {
    speed = value;
    controller!.setPlaybackSpeed(speed);
  }

  newVideo(int indx, String cleanedTitle) async {
    String pathDirectory = await FileStorage.getPath(titleOfPlayList);
    String path = "$pathDirectory/$cleanedTitle.mp4";
    await init(path);
    idx = indx;
  }

  @override
  void toggle() {
    if (controller!.value.isPlaying) {
      controller!.pause();
    } else {
      controller!.play();
    }
  }

  @override
  void restorePlaybackPosition() async {
    double percent = await Shared.getPrecentVideo(super.title);
    if (percent == 0) return;

    if (controller != null) {
      if (controller!.value.isInitialized) {
        int pos = (percent * controller!.value.duration.inSeconds).toInt();
        controller!.seekTo(Duration(seconds: pos));
        notifyListeners();
      } else {
        late VoidCallback listener;
        listener = () {
          if (controller!.value.isInitialized) {
            int pos = (percent * controller!.value.duration.inSeconds).toInt();
            controller!.seekTo(Duration(seconds: pos));
            notifyListeners();

            controller!.removeListener(listener);
          }
        };

        controller!.addListener(listener);
      }
    }
  }

  @override
  void dispose() {
    savePlaybackPosition();
    controller?.dispose();
    WakelockPlus.disable();
    super.dispose();
  }
}
