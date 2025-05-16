import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:no_noise/constant/texts.dart';
import 'package:no_noise/functions/check_internet.dart';
import 'package:no_noise/service/get_videos_service.dart';
import 'package:no_noise/service/save_data_in_file_json.dart';

class ViewPlaylistVideosCtrl extends ChangeNotifier {
  ViewPlaylistVideosCtrl({required this.playlistId});

  final String playlistId;
  List dataAll = [];
  bool isLoading = false;
  // 2. النسخة المحدثة من getPlaylistVideos
  Future<List<Map<String, dynamic>>> getPlaylistVideos() async {
    final String playlistUrl =
        "https://www.googleapis.com/youtube/v3/playlistItems?"
        "part=snippet,contentDetails&"
        "playlistId=$playlistId&"
        "maxResults=50&"
        "key=$apiKey";

    try {
      final response = await http.get(Uri.parse(playlistUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Map<String, dynamic>> localVideos = [];

        if (data['items'] != null) {
          // جمع كل الـ IDs في قائمة
          List<String> videoIds = [];
          for (var item in data['items']) {
            if (item['contentDetails']?['videoId'] != null) {
              videoIds.add(item['contentDetails']['videoId']);
            }
          }

          // جلب كل المدد مرة واحدة
          Map<String, String> durations =
              await GetVideosService.getBatchDurations(videoIds);

          // بناء قائمة الفيديوهات
          for (var item in data['items']) {
            try {
              final contentDetails = item['contentDetails'];
              final snippet = item['snippet'];

              if (contentDetails == null || snippet == null) continue;

              String videoId = contentDetails['videoId'];
              String thumbnail = snippet['thumbnails']?['high']?['url'] ?? '';
              if (thumbnail.isEmpty) continue;

              final videoData = {
                'title': snippet['title'],
                'videoId': videoId,
                'duration': durations[videoId] ?? 'Unknown',
                'thumbnail': thumbnail,
                'videoUrl': "https://www.youtube.com/watch?v=$videoId",
              };
              dataAll.add(videoData);
              notifyListeners();

              localVideos.add(videoData);
            } catch (e) {
              print("Error in video item: $e");
            }
          }
        }
        return localVideos;
      }
      return [];
    } catch (e) {
      print("Error in getPlaylistVideos: $e");
      return [];
    }
  }

  Future<void> comparisonBetweenLocalAndOnlinData(String path) async {
    if (await checkInternet()) {
      List readFromJson = await SaveDataInFileJson.readYoutube(path);
      List onlineData = await getPlaylistVideos();

      if (GetVideosService().areListsEqual(readFromJson, onlineData)) {
        print("✅ البيانات المحلية والبيانات من الإنترنت متطابقة.");
      } else {
        print("❌ البيانات مختلفة. سيتم حذف الملف المحلي.");
        await SaveDataInFileJson.deleteFile(path);

        if (await checkInternet()) {
          List data = await getPlaylistVideos();
          dataAll.clear();
          dataAll.addAll(data);
          notifyListeners();

          String updatedJsonString = jsonEncode(data);
          await SaveDataInFileJson.writeTemp(path, updatedJsonString);
        }
      }
    }
  }

  Future readDataFromYoutube(String path) async {
    isLoading = true;
    notifyListeners();
    List readFromJson = await SaveDataInFileJson.readYoutube(path);
    if (readFromJson.isNotEmpty) {
      log("From Json");
      dataAll = readFromJson;
      isLoading = false;
      notifyListeners(); // يعرض البيانات القديمة فورًا
    } else {
      log("From Internet");

      if (await checkInternet()) {
        await getPlaylistVideos();
        isLoading = false;
        notifyListeners();

        String updatedJsonString = jsonEncode(dataAll);
        await SaveDataInFileJson.writeTemp(path, updatedJsonString);
        print("finish");
      }
    }
    // أبدأ المقارنة بدون انتظار
    comparisonBetweenLocalAndOnlinData(path);
  }

}
