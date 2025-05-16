import 'dart:io';
import 'package:flutter/material.dart';
import 'package:no_noise/service/file_storage.dart';

class VideoStreamCtrl extends ChangeNotifier {
  VideoStreamCtrl({
    required this.video,
    required this.index,
    required this.title,
    required this.titleOfPlayList,
  });
  final List video;
  final int index;
  final String title;
  final String titleOfPlayList;
  //======== Variables ============
  String? pathFile;

  Stream<bool> init() async* {
    try {
      if (await FileStorage.checkExist(
        dir: titleOfPlayList,
        fileName: title,
        format: "mp4",
      )) {
        String pathDirectory = await FileStorage.getPath(titleOfPlayList);
        pathFile = "$pathDirectory/$title.mp4";
        final File file = File(pathFile!);
        if (await file.length() > 10) {
          yield true;
        } else {
          yield false;
        }
      } else {
        yield false;
      }
    } catch (e) {
      yield false;
    }
  }
}
