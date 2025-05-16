import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_noise/constant/texts.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/view/widgets/custom_app_bar.dart';
import 'package:no_noise/view/widgets/stylish_card.dart';
import 'package:provider/provider.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: customAppBar(theme: theme, title: "حول التطبيق"),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                "========== بسم الله الرحمن الرحيم ==========",
                style: GoogleFonts.amiri(color: theme.fontColor, fontSize: 19),
              ),
              const SizedBox(height: 20),
              //=================
              StylishCard(
                height: 350,
                title:
                    " عن حذيفة رضي الله عنه، قال : سمعت رسول الله - صلى الله عليه وسلم - يقول :",
                body:
                    "\" تعرض الفتن على القلوب كالحصير عودا عودا ، فأي قلب أشربها نكتت فيه نكتة سوداء ، وأي قلب أنكرها نكتت له نكتة بيضاء ، حتى يصير على قلبين : أبيض مثل الصفا ، فلا تضره فتنة ما دامت السماوات والأرض ، والآخر أسود مربادا كالكوز مجخيا لا يعرف معروفا ولا ينكر منكرا إلا ما أشرب من هواه \" . رواه مسلم .",
                footer: "",
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: theme.fontColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          about,
                          style: GoogleFonts.amiri(
                            color: theme.fontColor,
                            fontSize: 18,
                          ),
                        ),
                        const Divider(),
                        Text(
                          textAlign: TextAlign.center,
                          "كما يتيح التطبيق لكل مستخدم إمكانية إضافة أي سلسلة تعليمية يرغب بها من اليوتيوب، ومتابعتها هنا بكل تركيز، بعيدًا عن الإعلانات والمشتتات وضجيج المنصات الأخرى.",
                          style: GoogleFonts.amiri(
                            color: theme.fontColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: theme.fontColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      "ايها الاخوة لا تنسوا إخوانكم في غزة وفي كل ارض الاسلام من الدعاء\nاللهم اعد المسجد الاقصى الي رحاب المسلمين ",
                      style: GoogleFonts.amiri(
                        fontSize: 16,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                        color: theme.fontColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: theme.fontColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      'نسأل الله أن ينفع بهذا التطبيق كل من يستخدمه، وأن يجعله في ميزان حسناتنا جميعًا.\nولا تنسونا من صالح دعائكم 🌿',
                      style: GoogleFonts.amiri(
                        fontSize: 16,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                        color: theme.fontColor,
                      ),
                    ),
                  ),
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
