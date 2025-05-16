import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:no_noise/constant/texts.dart';

class GetVideosService {
 

  static Future<Map<String, String>> getBatchDurations(
    List<String> videoIds,
  ) async {
    final String videoUrl =
        "https://www.googleapis.com/youtube/v3/videos?"
        "part=contentDetails&"
        "id=${videoIds.join(',')}&"
        "key=$apiKey";

    try {
      final response = await http.get(Uri.parse(videoUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Map<String, String> durations = {};

        if (data['items'] != null) {
          for (var item in data['items']) {
            String id = item['id'];
            String duration = parseDuration(item['contentDetails']['duration']);
            durations[id] = duration;
          }
        }
        return durations;
      }
      return {};
    } catch (e) {
      print("Error in batch durations: $e");
      return {};
    }
  }

  static String parseDuration(String isoDuration) {
    final duration = Duration(
      hours: _parseTimeUnit(isoDuration, 'H'),
      minutes: _parseTimeUnit(isoDuration, 'M'),
      seconds: _parseTimeUnit(isoDuration, 'S'),
    );
    return duration.toString().substring(0, 7); // 00:00:00.000 -> 00:00:00
  }

  static int _parseTimeUnit(String input, String unit) {
    final regex = RegExp('(\\d+)$unit');
    return int.parse(regex.firstMatch(input)?.group(1) ?? '0');
  }

  bool areListsEqual(List<dynamic> a, List<dynamic> b) {
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i]['videoId'] != b[i]['videoId'] ||
          a[i]['title'] != b[i]['title'] ||
          a[i]['duration'] != b[i]['duration'] ||
          a[i]['thumbnail'] != b[i]['thumbnail']) {
        return false;
      }
    }
    return true;
  }
}
