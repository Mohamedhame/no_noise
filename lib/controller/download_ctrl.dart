import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:no_noise/functions/check_internet.dart';
import 'package:no_noise/service/db_helper.dart';
import 'package:no_noise/service/file_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadCtrl extends ChangeNotifier {
  DownloadCtrl({required this.folderName, required this.url}) {
    getDataFromSql();
  }
  final String folderName;
  final String url;

  // متغيرات الحالة
  final YoutubeExplode yt = YoutubeExplode();
  double percent = 0.0;
  double _videoProgress = 0.0;
  double _audioProgress = 0.0;

  bool isQualities = false;
  bool isDownloading = false;
  bool isCompleted = false;
  bool isLoading = false;
  bool internet = true;
  List<Map<String, dynamic>> dataInDatabase = [];
  String videoTitle = "";
  List<Map<String, dynamic>> videoQualities = [];
  String? extension;
  DBHelper dbHelper = DBHelper();
  int? newId;
  int? currentIndex;
  String? currentTitle;

  // ========== استخراج المعلومات ==========
  Future<void> fetchVideoQualities() async {
    if (!await checkInternet()) {
      internet = false;
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      final videoId = url;
      final video = await yt.videos.get(videoId);
      final manifest = await yt.videos.streams.getManifest(videoId);
      final audioStreams =
          manifest.audioOnly.toList()
            ..sort((a, b) => b.bitrate.compareTo(a.bitrate));
      AudioOnlyStreamInfo selectedAudioStream = audioStreams.first;
      final audioSize = selectedAudioStream.size;
      extension = selectedAudioStream.container.name;
      UnmodifiableListView<VideoOnlyStreamInfo> videoStreams =
          manifest.videoOnly;
      final Map<String, Map<String, dynamic>> tempQualities = {};
      videoTitle = sanitizeFileName(video.title);
      for (var element in videoStreams) {
        if (element.container.name == "mp4") {
          String quality = element.qualityLabel;
          if (!tempQualities.containsKey(quality) ||
              element.size.totalBytes >
                  tempQualities[quality]!['size'].totalBytes) {
            double totalKB =
                element.size.totalKiloBytes + audioSize.totalKiloBytes;
            final videoInfo = videoStreams.firstWhere(
              (stream) => stream.qualityLabel == element.qualityLabel,
            );
            tempQualities[quality] = {
              "videoTitle": videoTitle,
              "quality": quality,
              "size": element.size,
              "totalSize": formatFileSize(totalKB),
              "url": element.url,
              "extension": selectedAudioStream.container.name,
              "audioSize": selectedAudioStream.size.totalBytes,
              "urlAudio": selectedAudioStream.url.toString(),
              "urlVideo": videoInfo.url.toString(),
              "videoSize": videoInfo.size.totalBytes,
            };
          }
        }
      }

      videoQualities = tempQualities.values.toList();
      isQualities = videoQualities.isNotEmpty;
    } catch (e) {
      log("❌ fetch error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ========== تحميل ==========
  Future<void> templateDownload(
    String pathFile,
    String url,
    int fullSizeInBytes,
    bool isVideo,
  ) async {
    int downloaded = 0;
    final file = File(pathFile);
    if (await file.exists()) downloaded = await file.length();

    final raf = await file.open(mode: FileMode.append);
    final request = await HttpClient().getUrl(Uri.parse(url));

    if (downloaded > 0) request.headers.add("Range", "bytes=$downloaded-");

    final response = await request.close();

    if (response.statusCode != 206 && downloaded > 0) {
      await raf.close();
      await file.delete();
      downloaded = 0;
      return templateDownload(pathFile, url, fullSizeInBytes, isVideo);
    }

    int currentLength = downloaded;
    double lastSavedPercent = percent;

    await for (final chunk in response) {
      if (!isDownloading) break;
      raf.writeFromSync(chunk);
      currentLength += chunk.length;

      double progress = currentLength / fullSizeInBytes;

      if (isVideo) {
        _videoProgress = progress;
      } else {
        _audioProgress = progress;
      }

      percent = ((_videoProgress + _audioProgress) / 2) * 100;
      notifyListeners();

      // تحديث قاعدة البيانات عند كل تقدم (بدون شرط 5%)
      if (newId != null && (percent - lastSavedPercent) >= 1) {
        lastSavedPercent = percent;
        await updateData(videoTitle);
      }
    }

    await raf.close();
  }

  // تعديل دالة startDownload لضمان تعيين newId عند استرجاع البيانات من قاعدة البيانات
  Future<void> startDownload(
    int index, {
    List<Map<String, dynamic>>? data,
    int? id,
    required String titil,
  }) async {
    currentIndex = index;
    currentTitle = titil;
    notifyListeners();

    double savedPercent = 0.0;
    if (data != null && id != null) {
      Map<String, dynamic>? dbData = await dbHelper.getDownloadByTitle(titil);
      if (dbData != null &&
          dbData['status'] != null &&
          dbData['status'] != "completed") {
        videoTitle = dbData['title'];
        newId = dbData['id']; // تعيين newId من قاعدة البيانات هنا
        String statusStr = dbData['status'].toString();
        if (statusStr.contains("%")) {
          savedPercent = double.tryParse(statusStr.split("%")[0].trim()) ?? 0.0;
        }
      }
    }

    resetDownloadState();

    if (savedPercent > 0) {
      percent = savedPercent;
      _videoProgress = savedPercent / 100;
      _audioProgress = savedPercent / 100;
      notifyListeners();
    }

    isDownloading = true;
    notifyListeners();

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    if (data != null) {
      videoQualities = data;
      notifyListeners();
    }

    final cleanTitle = sanitizeFileName(videoTitle);
    final path = await FileStorage.getPath(folderName);
    extension = videoQualities[index]['extension'];
    final videoPath = '$tempPath/${cleanTitle}_video.mp4';
    final audioPath = '$tempPath/${cleanTitle}_audio.$extension';
    final outputPath = '$path/$cleanTitle.mp4';

    final int videoSize = videoQualities[index]['videoSize'];
    final int audioSize = videoQualities[index]['audioSize'];

    final mergedFile = File(outputPath);
    if (await mergedFile.exists()) await mergedFile.delete();

    try {
      if (data != null) {
        videoQualities = data;
        if (newId == null && id != null) {
          newId = id;
        }
        await updateData(videoTitle);
      } else {
        newId = await insertIntoSql(dataList: videoQualities, index: index);
        notifyListeners();
        await getDataFromSql();
      }
      await Future.wait([
        templateDownload(
          videoPath,
          videoQualities[index]['urlVideo'],
          videoSize,
          true,
        ),
        templateDownload(
          audioPath,
          videoQualities[index]['urlAudio'],
          audioSize,
          false,
        ),
      ]);

      if (percent >= 99.9) {
        isCompleted = true;
        notifyListeners();
        await updateData(videoTitle);
        await getDataFromSql();
        await mergeVideoAndAudio(videoTitle, deleteSources: true);
      }
    } catch (e) {
      print("❌ أثناء التحميل: $e");
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }

  // ========== دمج ==========

  Future<void> mergeVideoAndAudio(
    String titleOfVideo, {
    bool deleteSources = false,
  }) async {
    try {
      final cleanTitle = sanitizeFileName(videoTitle);
      final path = await FileStorage.getPath(folderName);
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      final ext = extension;
      final videoPath = '$tempPath/${cleanTitle}_video.mp4';
      final audioPath = '$tempPath/${cleanTitle}_audio.$ext';
      final outputPath = '$path/$cleanTitle.mp4';

      await updateData(titleOfVideo);

      await FFmpegKit.execute(
        '-i "$videoPath" -i "$audioPath" -c copy "$outputPath"',
      );

      print("📦 تم دمج الفيديو إلى: $outputPath");

      if (deleteSources) {
        if (await File(videoPath).exists()) await File(videoPath).delete();
        if (await File(audioPath).exists()) await File(audioPath).delete();
        print("🧹 حذف الملفات المؤقتة.");
      }
    } catch (e) {
      print("❌ فشل الدمج: $e");
    }
  }

  // ========== إيقاف / إعادة ==========

  void stopDownload(String titleOfVideo) async {
    if (isDownloading) {
      isDownloading = false;
      notifyListeners();
      print("⏸️ تم إيقاف التحميل.");

      await mergeVideoAndAudio(titleOfVideo, deleteSources: isCompleted);

      await getDataFromSql();
    }
  }

  void resetDownloadState() {
    percent = 0.0;
    _videoProgress = 0.0;
    _audioProgress = 0.0;
    isCompleted = false;
    notifyListeners();
  }

  // ========== Database ============== //
  Future<int> insertIntoSql({
    required List<Map<String, dynamic>> dataList,
    required int index,
  }) async {
    String date = DateTime.now().toString().split(" ")[0];

    List<Map<String, dynamic>> sanitizedList =
        dataList.map((item) {
          return item.map((key, value) {
            if (value is Uri) {
              return MapEntry(key, value.toString());
            }
            return MapEntry(key, value);
          });
        }).toList();

    Map<String, dynamic> data = {
      "data": json.encode(sanitizedList),
      "idx": index,
      "title": videoTitle,
      "status": percent,
      "date": date,
    };

    return dbHelper.insertDownload(data);
  }

  Future<void> updateData(String titleOfVideo) async {
    Map<String, dynamic>? data = await dbHelper.getDownloadByTitle(
      titleOfVideo,
    );

    if (data != null) {
      final editableData = Map<String, dynamic>.from(data);
      final statusValue =
          isCompleted ? "completed" : "${percent.toStringAsFixed(2)} %";
      editableData['status'] = statusValue;

      await dbHelper.updateDownload(Map<String, dynamic>.from(editableData));
      print(editableData);
    } else {
      print("===============");
    }
  }



  Future<void> getDataFromSql() async {
    dataInDatabase = await dbHelper.getDownloads();
    notifyListeners();
  }

  // ========== أدوات مساعدة ==========
  String sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[:!@#%^&*(),.?":{}|<>]'), '');
  }

  String formatFileSize(double kb) {
    if (kb >= 1024 * 1024) {
      return "${(kb / (1024 * 1024)).toStringAsFixed(2)} GB";
    }
    if (kb >= 1024) return "${(kb / 1024).toStringAsFixed(2)} MB";
    return "${kb.toStringAsFixed(2)} KB";
  }
}
