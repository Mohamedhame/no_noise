import 'package:flutter/material.dart';
import 'package:no_noise/constant/texts.dart';
import 'package:no_noise/controller/individual_video_ctrl.dart';
import 'package:no_noise/controller/list_of_playlist_ctrl.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/controller/view_playlist_videos_ctrl.dart';
import 'package:no_noise/view/page/video/view_individual_videos.dart';
import 'package:no_noise/view/page/video/view_playlist_videos.dart';
import 'package:no_noise/view/widgets/custom_app_bar.dart';
import 'package:no_noise/view/widgets/custom_design_buuton.dart';
import 'package:no_noise/view/widgets/videos/custom_add_playlist.dart';
import 'package:no_noise/view/widgets/videos/custom_alert_dialog_to_add_videos.dart';
import 'package:no_noise/view/widgets/videos/custom_error_alert.dart';
import 'package:no_noise/view/widgets/videos/warning_alert.dart';
import 'package:provider/provider.dart';

class ListOfPlaylist extends StatelessWidget {
  const ListOfPlaylist({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    final model = Provider.of<ListOfPlaylistCtrl>(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: customAppBar(theme: theme, title: "قوائم التشغيل"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: model.data.length,
              itemBuilder: (context, index) {
                String title = model.data[index]['text'];
                bool onVideo = model.data[index]['isOneVideo'];
                return CustomDesignBuuton(
                  titleItem: onVideo ? "$title [قائمة تشغيل خاصة بك]" : title,
                  widget:
                      index > 1
                          ? InkWell(
                            onTap: () async {
                              // model.deleteFromShared(index);
                              await model.checkFolderContent(index);
                              if (!model.hasFolderExite) {
                                model.deleteFromShared(index);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return WarningAlert(
                                      warningTitle: "تنبية",
                                      warningBody:
                                          "$worningBodyInPlayListAfterItem ${model.numberOfItem}",
                                      finalDelete: () {
                                        model.finalDelete(index);
                                        Navigator.of(context).pop();
                                      },
                                      deleteFromApp: () {
                                        model.deleteFromShared(index);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            child: Icon(Icons.delete, color: theme.fontColor),
                          )
                          : null,
                  onTap: () {
                    if (model.data[index]['isOneVideo']) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => ChangeNotifierProvider(
                                create:
                                    (context) => IndividualVideoCtrl(
                                      playListName: model.data[index]['text'],
                                    ),
                                child: ViewIndividualVideos(
                                  data: model.data[index],
                                ),
                              ),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => ChangeNotifierProvider(
                                create:
                                    (context) => ViewPlaylistVideosCtrl(
                                      playlistId:
                                          model.data[index]['playlistId'],
                                    )..readDataFromYoutube(
                                      model.data[index]['path'],
                                    ),
                                child: ViewPlaylistVideos(
                                  data: model.data[index],
                                ),
                              ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),

          CustomAddPlaylist(
            isOnlyVideo: false,
            theme: theme,
            text: noNoise,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialogToAddVideos(
                    isCreate: false,
                    model: model,
                    onTap: () {
                      if (model.formState.currentState!.validate()) {
                        model.addToData();
                        Navigator.of(context).pop();
                        if (model.isOnlyVideo) {
                          model.showError(
                            context,
                            CustomErrorAlert(
                              messageError:
                                  "لا بد من إضافة قائمة تشغيل فقط في هذا الحقل",
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
            create: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialogToAddVideos(
                    model: model,
                    isCreate: true,
                    onTap: () {
                      if (model.formState.currentState!.validate()) {
                        model.createPlayList();
                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
