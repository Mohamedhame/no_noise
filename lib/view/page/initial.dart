import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/utilities/routes.dart';

class Initial extends StatefulWidget {
  const Initial({super.key});

  @override
  State<Initial> createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // خلفية الصورة
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/no_noise.png"),
                    //fit: BoxFit.cover, // مهم جداً لتغطية الخلفية
                  ),
                ),
              ),
            ),

            // النص في أسفل الشاشة
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "The application was designed by Mohamed Hamed",
                  style: GoogleFonts.amiri(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
