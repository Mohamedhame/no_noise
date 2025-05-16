import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/service/shared.dart';

class CustomNotes extends StatelessWidget {
  const CustomNotes({
    super.key,
    required this.isPortrait,
    required this.textEditingController,
    required this.title,
  });

  final bool isPortrait;
  final TextEditingController textEditingController;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: isPortrait ? 400 : 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Shared.setNotes(title, textEditingController.text);
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.check),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TextField(
              style: GoogleFonts.amiri(color: Colors.white),
              controller: textEditingController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
