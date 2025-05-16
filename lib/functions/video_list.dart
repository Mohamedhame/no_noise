import 'package:no_noise/service/shared.dart';

videoList() async {
  List data = [
    {
      "text": "تيسير مصطلح الحديث",
      "playlistId": "PLWH2kEvwZ2mP2UUtkLQzJVrh0PkKd0o9G",
      "path": 'taysir.json',
      "isOneVideo": false,
    },
    {
      "text": "رحلة اليـقـين",
      "playlistId": "PL56IcDjrf3YJr__TEOJ2UOv3jCzht1_yc",
      "path": 'rehlat.json',
      "isOneVideo": false,
    },
  ];
  List video = await Shared.getListsOfVideos();
  if (video.isEmpty) {
    Shared.setListsOfVideos(data);
  }
}
