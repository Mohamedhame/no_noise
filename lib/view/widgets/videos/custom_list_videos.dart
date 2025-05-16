import 'package:flutter/material.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/functions/clean_title.dart';
import 'package:no_noise/service/shared.dart';
import 'package:no_noise/view/page/video/video_stream.dart';
import 'package:no_noise/view/widgets/videos/custom_list_view_video.dart';
import 'package:no_noise/view/widgets/videos/custom_widgets_downlod.dart';
import 'package:provider/provider.dart';

class CustomListVideos extends StatelessWidget {
  const CustomListVideos({
    super.key,
    required this.data,
    required this.titleOfPlayList,
    this.onPressedOnlinVideo,
    this.onPressedLocalVideo,
    this.widget,
  });
  final List data;
  final String titleOfPlayList;
  final void Function(int)? onPressedOnlinVideo;
  final void Function(int, String)? onPressedLocalVideo;
  final bool? widget;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        if (data.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return FutureBuilder(
          future: Shared.getPrecentVideo(cleanTitle(data, index)),
          builder: (context, snapshot) {
            return CustomListViewVideos(
              imageUrl: data[index]['thumbnail'],
              textTitle: data[index]['title'] ?? "",
              textDuration: data[index]['duration'] ?? "",
              percent: snapshot.data ?? 0,
              widget: Row(
                children: [
                  CustomWidgetsDownlod(
                    folderName: titleOfPlayList,
                    url: data[index]['videoUrl'],
                    title: cleanTitle(data, index),
                  ),
                  if (widget != null)
                    InkWell(
                      onTap: () {
                        onPressedOnlinVideo?.call(index);
                      },
                      child: Icon(Icons.delete, color: theme.fontColor),
                    ),
                ],
              ),
              onTap: () {
                String cleanedTitle = cleanTitle(data, index);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => VideoStream(
                          video: data,
                          index: index,
                          title: cleanedTitle,
                          titleOfPlayList: titleOfPlayList,
                        ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
