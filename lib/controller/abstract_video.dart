import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AbstractVideo extends ChangeNotifier {
  final List video;
  final int index;
  final String title;
  final String titleOfPlayList;

  AbstractVideo({
    required this.video,
    required this.index,
    required this.title,
    required this.titleOfPlayList,
  });

  List<double> speadList = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  // init();
  bool portrait(BuildContext context);
  void nextVideo(BuildContext context);
  void toggle();
  void previous(BuildContext context);
  void forward10();
  void rewind10();
  void increaseSpead();
  void decreaseSpead();
  getNotes();
  double formatPosition(Duration val) => val.inSeconds.toDouble();


  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void changePositionScreen(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }

    notifyListeners();
  }

  void selectOfSpeedFromSlider(double value);
  void savePlaybackPosition();
  void restorePlaybackPosition();


}
