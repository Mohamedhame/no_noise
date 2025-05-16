import 'package:flutter/material.dart';
import 'package:no_noise/constant/texts.dart';
import 'package:no_noise/controller/individual_video_ctrl.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/view/widgets/custom_app_bar.dart';
import 'package:no_noise/view/widgets/videos/custom_add_playlist.dart';
import 'package:no_noise/view/widgets/videos/custom_alert_dialog_to_add_videos.dart';
import 'package:no_noise/view/widgets/videos/custom_list_videos.dart';
import 'package:no_noise/view/widgets/videos/warning_alert.dart';
import 'package:provider/provider.dart';

class ViewIndividualVideos extends StatelessWidget {
  const ViewIndividualVideos({super.key, required this.data});
  final Map data;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: customAppBar(theme: theme, title: data['text']),
      body: Consumer<IndividualVideoCtrl>(
        builder: (context, model, child) {
          return Column(
            children: [
              Expanded(
                child: CustomListVideos(
                  data: model.data,
                  titleOfPlayList: model.playListName,
                  widget: true,
                  onPressedOnlinVideo: (index) async {
                    if (await model.askDelete(index)) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return WarningAlert(
                            warningTitle: "تنبية",
                            warningBody: thisVideoIsSaved,
                            finalDelete: () {
                              model.finalDelete(index);
                              Navigator.of(context).pop();
                            },
                            deleteFromApp: () {
                              model.deleteData(index);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    } else {
                      model.deleteData(index);
                    }
                    // model.deleteData(p0);
                    // print(await model.askDelete(p0));
                    // if (model.active) {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return AlertDialog(
                    //       content: Column(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Align(
                    //             alignment: Alignment.topRight,
                    //             child: Text("تنبية"),
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // );
                    // }
                  },
                ),
              ),
              CustomAddPlaylist(
                isOnlyVideo: true,
                text: onlyVideo,
                theme: theme,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialogToAddVideos(
                        isCreate: true,
                        model: model,
                        altText: labelOfLinkVideo,
                        onTap: () {
                          model.fetchYouTubeVideoInfo();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }
}
