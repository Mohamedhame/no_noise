import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class CustomListViewVideos extends StatelessWidget {
  const CustomListViewVideos({
    super.key,
    required this.imageUrl,
    required this.textTitle,
    required this.textDuration,
    required this.percent,
    this.widget,
    this.onTap,
  });

  final String imageUrl;
  final String textTitle;
  final String textDuration;
  final double? percent;
  final Widget? widget;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.fontColor, width: 0.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onTap,
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Stack(
                        children: [
                          CachedNetworkImage(imageUrl: imageUrl),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              width: double.infinity,
                              height: 5,
                              child: LinearPercentIndicator(
                                percent: (percent ?? 0).clamp(0.0, 1.0),
                                width: 120,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),

                        child: Column(
                          children: [
                            Text(
                              textTitle,

                              style: GoogleFonts.amiri(color: theme.fontColor),
                            ),
                            Row(
                              textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "المدة",
                                  style: GoogleFonts.amiri(
                                    color: theme.fontColor,
                                  ),
                                ),
                                Text(
                                  textDuration,
                                  style: GoogleFonts.amiri(
                                    color: theme.fontColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget != null) widget ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
