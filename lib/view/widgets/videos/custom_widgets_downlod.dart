import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:no_noise/controller/download_ctrl.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/service/file_storage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class CustomWidgetsDownlod extends StatelessWidget {
  const CustomWidgetsDownlod({
    super.key,
    required this.folderName,
    required this.url,
    required this.title,
  });
  final String folderName;
  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => DownloadCtrl(folderName: folderName, url: url),
      child: Consumer<DownloadCtrl>(
        builder: (context, model, child) {
          // =========== Progress Download ===================
          if (model.isDownloading) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularPercentIndicator(
                radius: 25,
                percent: (model.percent / 100).clamp(0.0, 1.0),
                progressColor: Colors.redAccent,
                backgroundColor: Colors.greenAccent,
                center: InkWell(
                  onTap: () {
                    model.stopDownload(title);
                  },
                  child: Text(
                    "${model.percent.toStringAsFixed(2)}%",
                    style: TextStyle(color: theme.fontColor),
                  ),
                ),
              ),
            );
          }
          int index = model.dataInDatabase.indexWhere(
            (item) => item['title'] == title,
          );
          if (index != -1) {
            int idx = model.dataInDatabase[index]['idx'];
            List<Map<String, dynamic>> decodedList =
                List<Map<String, dynamic>>.from(
                  json.decode(model.dataInDatabase[index]['data']),
                );
            String status = model.dataInDatabase[index]['status'];
            if (status == "completed") {
              return Icon(Icons.done_all, color: theme.fontColor);
            } else {
              // =============== Wating ======================
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.fontColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        model.startDownload(
                          idx,
                          data: decodedList,
                          id: model.dataInDatabase[index]['id'],
                          titil: title,
                        );
                      },
                      child: Text(
                        status,
                        style: TextStyle(color: theme.primaryColor),
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return FutureBuilder(
              future: FileStorage.checkExist(
                dir: folderName,
                fileName: title,
                format: "mp4",
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                } else if (snapshot.data!) {
                  return Icon(Icons.done_all, color: theme.fontColor);
                } else {
                  return GestureDetector(
                    onTapUp: (details) async {
                      double dx = details.globalPosition.dx;
                      double dy = details.globalPosition.dy;
                      double right = MediaQuery.of(context).size.width - dx;
                      double bottom = MediaQuery.of(context).size.width - dy;
                      await model.fetchVideoQualities();
                      if (model.isQualities) {
                        showMenu(
                          color: theme.primaryColor,
                          context: context,
                          position: RelativeRect.fromLTRB(
                            dx,
                            dy,
                            right,
                            bottom,
                          ),
                          items: [
                            ...List.generate(model.videoQualities.length, (i) {
                              String value = model.videoQualities[i]['quality'];
                              return PopupMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: theme.fontColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            model.videoQualities[i]['quality']
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            model.videoQualities[i]['totalSize']
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  model.startDownload(i, titil: title);
                                  // print(model.videoQualities[i]);
                                  // print(item);
                                },
                              );
                            }),
                          ],
                        );
                      }
                    },
                    child:
                        model.isLoading
                            ? CircularProgressIndicator()
                            : Icon(Icons.download, color: theme.fontColor),
                  );
                }
              },
            );

            //
          }
        },
      ),
    );
  }
}
