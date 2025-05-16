import 'dart:io';
import 'package:no_noise/service/file_storage.dart';
class CheckExit {
  static Future<bool> checkExist({
    required String dir,
    required String fileName,
    required String format,
  }) async {
    String pathDirectory = await FileStorage.getPath(dir);
    String pathFile = "$pathDirectory/$fileName.$format";
    final File file = File(pathFile);
    if (await file.exists()) {
      return true;
    } else {
      return false;
    }
  }
}
