import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileStorage {
  // Its function is to check the permission status of a particular device.
  static Future<bool> permissionReq(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result.isGranted;
    }
  }

  // Its function is to request storage permission in an application.
  static Future<bool> requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
        if (build.version.sdkInt >= 30) {
          await Permission.manageExternalStorage.request();
          if (await Permission.manageExternalStorage.isGranted) {
            return true;
          } else {
            return false;
          }
        } else {
          return await permissionReq(Permission.storage);
        }
      }
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  //Its function is to create a custom path within the external storage in Android system,
  static Future<String> pathFolder(String dir) async {
    Directory? docDir = await getExternalStorageDirectory();
    List<String> address = docDir!.path.split('/');
    List<String> newAddressList = [];
    for (var i = 0; i < address.length; i++) {
      if (i < 4) {
        newAddressList.add(address[i]);
      }
    }
    String newAddress = newAddressList.join("/");

    String relativePath = "$newAddress/zekr/$dir";
    return relativePath;
  }

  //Request storage permission first, then create a folder inside external storage if it doesn't exist, and return its path.
  static Future<String> getPath(String dir) async {
    await requestStoragePermission();
    try {
      String relativePath = await pathFolder(dir);
      Directory directory = Directory(relativePath);
      if (await directory.exists()) {
        return directory.path;
      } else {
        await directory.create(recursive: true);
        return directory.path;
      }
    } catch (e) {
      log("حدث خطأ: $e");
      return e.toString();
    }
  }

  // Check if a particular .mp3 file is located within a specific folder in external storage.
  static Future<bool> checkExist({
    required String dir,
    required String fileName,
    required String format,
  }) async {
    String pathDirectory = await getPath(dir);
    String pathFile = "$pathDirectory/$fileName.$format";
    final File file = File(pathFile);
    if (await file.exists()) {
      return true;
    } else {
      return false;
    }
  }

  // returen path of file
  static Future<String> urlFile({
    required String dir,
    required String fileName,
    required String format,
  }) async {
    String pathDirectory = await getPath(dir);
    String pathFile = "$pathDirectory/$fileName.$format";
    return pathFile;
  }

  // دالة لحذف ملف معين من مجلد معين في التخزين الخارجي
  static Future<bool> deleteFile({
    required String dir,
    required String fileName,
    required String format,
  }) async {
    try {
      // الحصول على مسار الملف
      String pathDirectory = await getPath(dir);
      String pathFile = "$pathDirectory/$fileName.$format";
      final File file = File(pathFile);

      // التأكد من وجود الملف ثم حذفه
      if (await file.exists()) {
        await file.delete();
        log("تم حذف الملف: $pathFile");
        return true;
      } else {
        log("الملف غير موجود: $pathFile");
        return false;
      }
    } catch (e) {
      log("خطأ أثناء حذف الملف: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> checkFolderContent(String dir) async {
    try {
      String pathDirectory = await getPath(dir);
      final Directory folder = Directory(pathDirectory);

      // الحصول على جميع الملفات (ليس المجلدات الفرعية)
      final List<FileSystemEntity> files =
          folder
              .listSync()
              .where((entity) => FileSystemEntity.isFileSync(entity.path))
              .toList();

      return {"hasFiles": files.isNotEmpty, "number": files.length};
    } catch (e) {
      log("خطأ أثناء فحص محتوى المجلد: $e");
      return {"hasFiles": false, "number": 0};
    }
  }

  static Future<bool> deleteFolder(String dir) async {
    try {
      String pathDirectory = await getPath(dir);
      final Directory folder = Directory(pathDirectory);

      if (await folder.exists()) {
        await folder.delete(recursive: true);
        log("تم حذف المجلد بكل محتوياته: $pathDirectory");
        return true;
      } else {
        log("المجلد غير موجود: $pathDirectory");
        return false;
      }
    } catch (e) {
      log("خطأ أثناء حذف المجلد: $e");
      return false;
    }
  }
}
