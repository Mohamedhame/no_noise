import 'package:flutter/material.dart';
import 'package:no_noise/controller/local_video_cnotrol.dart';
import 'package:provider/provider.dart';

class SkipPrevoius extends StatelessWidget {
  const SkipPrevoius({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalVideoControl>(
      builder: (context, model, child) {
        return Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                model.nextVideo(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.skip_next, size: 32, color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  model.toggle();
                },
                child: Icon(
                  model.controller!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  size: 32,
                  // color: theme.fontColor,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () async {
                model.previous(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.skip_previous, size: 32, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
