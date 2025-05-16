import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> setTheme(bool theme) async {
    await init();
    await _sharedPreferences!.setBool("theme", theme);
  }

  static Future<bool?> getTheme() async {
    await init();
    return _sharedPreferences!.getBool("theme");
  }

  static Future<bool> runOnlyOnFirstInstall() async {
    await init();
    final hasInitialized =
        _sharedPreferences!.getBool('has_initialized') ?? false;

    if (hasInitialized) {
      return false;
    }

    await _sharedPreferences!.setBool('has_initialized', true);
    return true;
  }

  static Future<void> setListsOfVideos(List value) async {
    await init();
    String jsonString = jsonEncode(value);
    await _sharedPreferences!.setString("video", jsonString);
  }

  static Future<List> getListsOfVideos() async {
    await init();
    String? jsonString = _sharedPreferences!.getString('video');
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return [];
  }

  static Future<void> setPrecentVideo(String key, double value) async {
    await init();
    _sharedPreferences!.setDouble(key, value);
  }

  static Future<double> getPrecentVideo(String key) async {
    await init();
    double? precent = _sharedPreferences!.getDouble(key);
    if (precent != null) {
      return precent;
    }
    return 0.0;
  }

  static Future<void> setNotes(String key, String value) async {
    await init();
    await _sharedPreferences!.setString(key, value);
  }

  static Future<String?> getNotes(String key) async {
    await init();
    String? notes = _sharedPreferences!.getString(key);
    if (notes != null) {
      return notes;
    }
    return null;
  }

  static Future<void> setSpicialVideos(String key, List value) async {
    await init();
    String jsonString = jsonEncode(value);
    await _sharedPreferences!.setString(key, jsonString);
  }

  static Future<List> getSpicialVideos(String key) async {
    await init();
    String? jsonString = _sharedPreferences!.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return [];
  }
}
