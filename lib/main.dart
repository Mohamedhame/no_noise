import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:no_noise/controller/list_of_playlist_ctrl.dart';
import 'package:no_noise/controller/theme_controller.dart';
import 'package:no_noise/functions/start_program.dart';
import 'package:no_noise/service/db_helper.dart';
import 'package:no_noise/utilities/router.dart';
import 'package:no_noise/utilities/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DBHelper().database;
  startProgram();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => ListOfPlaylistCtrl()),
      ],
      child: MaterialApp(
        title: 'No Noise = بلا ضجيج',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: Locale('ar'),
        supportedLocales: [Locale('ar'), Locale('en')],
        onGenerateRoute: onGenerateRoute,
        initialRoute: AppRoutes.initial,
      ),
    );
  }
}
