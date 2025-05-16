import 'package:flutter/material.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/controller/view_playlist_videos_ctrl.dart';
import 'package:no_noise/view/widgets/custom_app_bar.dart';
import 'package:no_noise/view/widgets/videos/custom_list_videos.dart';
import 'package:provider/provider.dart';

class ViewPlaylistVideos extends StatelessWidget {
  const ViewPlaylistVideos({super.key, required this.data});
  final Map data;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    final model = Provider.of<ViewPlaylistVideosCtrl>(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: customAppBar(theme: theme, title: data['text']),
      body: Column(
        children: [
          Expanded(
            child: CustomListVideos(
              data: model.dataAll,
              titleOfPlayList: data['text'],
            ),
          ),
        ],
      ),
    );
  }
}
