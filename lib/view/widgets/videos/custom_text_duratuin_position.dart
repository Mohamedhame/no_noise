import 'package:flutter/material.dart';

class CustomTextDurationPosition extends StatelessWidget {
  const CustomTextDurationPosition({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 25,
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}