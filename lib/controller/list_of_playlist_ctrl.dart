import 'package:flutter/material.dart';
import 'package:no_noise/functions/clean_title.dart';
import 'package:no_noise/service/db_helper.dart';
import 'package:no_noise/service/file_storage.dart';
import 'package:no_noise/service/shared.dart';

class ListOfPlaylistCtrl extends ChangeNotifier {
  ListOfPlaylistCtrl() {
    getListFromShared();
  }
  TextEditingController playlistName = TextEditingController();
  TextEditingController playlistLink = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isExit = false;
  bool isOnlyVideo = false;
  bool hasFolderExite = false;
  int numberOfItem = 0;
  List data = [];
  DBHelper db = DBHelper();

  getListFromShared() async {
    data = await Shared.getListsOfVideos();
    notifyListeners();
  }

  void addToData() async {
    if (data.any((item) => item["text"] == playlistName.text)) {
      isExit = true;
      notifyListeners();
      return;
    }

    String id = playlistLink.text;

    if (id.contains("list")) {
      id = playlistLink.text.split('list=').last;
      addToDataInShared(playlistId: id, isOne: false);
      resetFields();
    } else {
      isOnlyVideo = true;
      notifyListeners();
    }
  }

  showError(BuildContext context, Widget widget) {
    showDialog(context: context, builder: (context) => widget);
  }

  void createPlayList() {
    addToDataInShared(playlistId: "", isOne: true);
    resetFields();
  }

  void deleteFromShared(int index) async {
    data.removeAt(index);
    notifyListeners();
    await Shared.setListsOfVideos(data);
  }

  void addToDataInShared({
    required String playlistId,

    required bool isOne,
  }) async {
    String jsText = "${playlistName.text}.json";
    Map addData = {
      "text": playlistName.text,
      "playlistId": playlistId,
      "path": jsText,
      "isOneVideo": isOne,
    };
    data.add(addData);
    notifyListeners();
    await Shared.setListsOfVideos(data);
  }

  checkFolderContent(int index) async {
    Map d = await FileStorage.checkFolderContent(data[index]['text']);
    hasFolderExite = d['hasFiles'];
    numberOfItem = d['number'];
    notifyListeners();
  }

  finalDelete(int index) async {
    List itemsInPlaylist = await Shared.getSpicialVideos(data[index]['text']);
    for (var i = 0; i < itemsInPlaylist.length; i++) {
      db.deleteDownloadByTitle(cleanTitle(itemsInPlaylist, i));
    }
    itemsInPlaylist.clear();
    await Shared.setSpicialVideos(data[index]['text'], itemsInPlaylist);
    await FileStorage.deleteFolder(data[index]['text']);
    deleteFromShared(index);
  }

  void resetFields() {
    playlistLink.clear();
    playlistName.clear();
  }

  @override
  void dispose() {
    resetFields();
    super.dispose();
  }
}
