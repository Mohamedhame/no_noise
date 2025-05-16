import 'package:flutter/cupertino.dart';
import 'package:no_noise/utilities/routes.dart';
import 'package:no_noise/view/page/about.dart';
import 'package:no_noise/view/page/home_page.dart';
import 'package:no_noise/view/page/initial.dart';
import 'package:no_noise/view/page/video/list_of_playlist.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.listOfPlaylist:
      return CupertinoPageRoute(
        builder: (_) => ListOfPlaylist(),
        settings: settings,
      );
    case AppRoutes.about:
      return CupertinoPageRoute(
        builder: (_) => About(),
        settings: settings,
      );
    case AppRoutes.homePage:
      return CupertinoPageRoute(
        builder: (_) => HomePage(),
        settings: settings,
      );
    default:
      return CupertinoPageRoute(
        builder: (_) => const Initial(),
        settings: settings,
      );
  }
}
