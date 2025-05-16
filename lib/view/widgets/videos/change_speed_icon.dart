import 'package:flutter/material.dart';

class CustomChangeSpeadIcon extends StatelessWidget {
  const CustomChangeSpeadIcon({super.key, required this.icon, this.onTap});

  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: Icon(icon, color: const Color(0xff202020)),
        ),
      ),
    );
  }
}
