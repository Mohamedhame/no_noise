import 'package:no_noise/functions/video_list.dart';
import 'package:no_noise/service/shared.dart';

startProgram() async {
  final isFirstInstall = await Shared.runOnlyOnFirstInstall();
  if (isFirstInstall) {
    videoList();
  }
}
