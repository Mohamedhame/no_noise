import 'package:flutter/material.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/utilities/routes.dart';
import 'package:no_noise/view/widgets/custom_change_theme.dart';
import 'package:no_noise/view/widgets/custom_design_buuton.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            CustomChangeTheme(theme: theme),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      CustomDesignBuuton(
                        titleItem: "المرئيات",
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.listOfPlaylist);
                        },
                      ),
                      CustomDesignBuuton(
                        titleItem: "حول التطبيق",
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.about);
                        },
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
