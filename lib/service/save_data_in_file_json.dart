import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SaveDataInFileJson {
  //==== Write in json file =========
  static Future<void> writeTemp(String path, String text) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$path');
      await file.writeAsString(text);
      log("Save Data in ${file.path}");
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<List<Map<String, dynamic>>> readYoutube(String path) async {
    List<Map<String, dynamic>> names = [];
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$path');

      if (await file.exists()) {
        final text = await file.readAsString();

        if (text.isNotEmpty) {
          final List<dynamic> jsonData = jsonDecode(text);

          names =
              jsonData
                  .whereType<Map<String, dynamic>>() // تصفية مباشرة للأنواع
                  .toList();
        }
      }
    } catch (e) {
      print("Error reading file: $e");
    }
    return names;
  }

  static Future<void> deleteFile(String path) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$path');

      if (await file.exists()) {
        await file.delete(); // await لضمان الحذف قبل الخروج
        print('File deleted: ${file.path}');
      } else {
        print('File not found: ${file.path}');
      }
    } catch (e) {
      print("Error deleting file: $e");
    }
  }
}
