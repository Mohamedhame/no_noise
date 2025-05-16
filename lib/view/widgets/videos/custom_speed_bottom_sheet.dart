import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/controller/abstract_video.dart';
import 'package:no_noise/controller/local_video_cnotrol.dart';
import 'package:no_noise/controller/onlin_video_control.dart';
import 'package:no_noise/view/widgets/videos/change_speed_icon.dart';
import 'package:provider/provider.dart';

class CustomSpeedBottomSheet extends StatelessWidget {
  const CustomSpeedBottomSheet({super.key, required this.model});

  final AbstractVideo model;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: model.portrait(context) ? size.height * 0.4 : size.width * 0.35,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CustomChangeSpeadIcon(
                      // theme: theme,
                      icon: Icons.add,
                      onTap: model.increaseSpead,
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child:
                            model.runtimeType == LocalVideoControl
                                ? Selector<LocalVideoControl, double>(
                                  builder: (context, value, child) {
                                    return Slider(
                                      min: 0.4,
                                      value: value,
                                      max: 2.1,
                                      onChanged: model.selectOfSpeedFromSlider,
                                    );
                                  },
                                  selector: (p0, p1) => p1.speed,
                                )
                                : Selector<OnlinVideoControl, double>(
                                  builder: (context, value, child) {
                                    return Slider(
                                      min: 0.4,
                                      value: value,
                                      max: 2.1,
                                      onChanged: model.selectOfSpeedFromSlider,
                                    );
                                  },
                                  selector: (p0, p1) => p1.speed,
                                ),
                      ),
                    ),
                    CustomChangeSpeadIcon(
                      icon: Icons.remove,
                      onTap: model.decreaseSpead,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      textDirection: TextDirection.ltr,
                      children: [
                        ...List.generate(model.speadList.length, (index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  model.selectOfSpeedFromSlider(
                                    model.speadList[index],
                                  );
                                },
                                child: Text(
                                  model.speadList[index].toString(),
                                  style: TextStyle(
                                    color: const Color(0xff202020),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "سرعة التشغيل",
                      style: GoogleFonts.amiri(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    model.runtimeType == LocalVideoControl
                        ? Selector<LocalVideoControl, double>(
                          builder: (context, value, child) {
                            return Text(
                              value.toStringAsFixed(2),
                              style: TextStyle(color: Colors.white),
                            );
                          },
                          selector: (p0, p1) => p1.speed,
                        )
                        : Selector<OnlinVideoControl, double>(
                          builder: (context, value, child) {
                            return Text(
                              value.toString(),
                              style: TextStyle(color: Colors.white),
                            );
                          },
                          selector: (p0, p1) => p1.speed,
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
