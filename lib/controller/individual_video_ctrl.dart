import 'package:flutter/material.dart';
import 'package:no_noise/functions/clean_title.dart';
import 'package:no_noise/service/db_helper.dart';
import 'package:no_noise/service/file_storage.dart';
import 'package:no_noise/service/get_videos_service.dart';
import 'package:no_noise/service/shared.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class IndividualVideoCtrl extends ChangeNotifier {
  IndividualVideoCtrl({required this.playListName}) {
    getData();
  }
  final String playListName;
  List data = [];
  bool active = false;
  DBHelper db = DBHelper();

  TextEditingController playlistName = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  getData() async {
    data = await Shared.getSpicialVideos(playListName);
    notifyListeners();
  }

  Future<void> fetchYouTubeVideoInfo() async {
    String videoUrl = playlistName.text;
    var yt = YoutubeExplode();
    try {
      var video = await yt.videos.get(videoUrl);
      var videoId = video.id.value;
      final videoData = {
        'title': video.title,
        'videoId': videoId,
        'duration': GetVideosService.parseDuration(video.description),
        'thumbnail': video.thumbnails.highResUrl,
        'videoUrl': videoUrl,
      };
      data.add(videoData);
      notifyListeners();
      Shared.setSpicialVideos(playListName, data);
    } catch (e) {
      print('Error: $e');
      return;
    } finally {
      yt.close();
    }
  }

  deleteData(int index) async {
    data.removeAt(index);
    notifyListeners();
    Shared.setSpicialVideos(playListName, data);
  }

  finalDelete(int index) async {
    await db.deleteDownloadByTitle(cleanTitle(data, index));
    await FileStorage.deleteFile(
      dir: playListName,
      fileName: cleanTitle(data, index),
      format: "mp4",
    );
    deleteData(index);
  }

  Future<bool> askDelete(int index) async {
    bool isExit = await FileStorage.checkExist(
      dir: playListName,
      fileName: cleanTitle(data, index),
      format: "mp4",
    );

    return isExit;
  }
}
