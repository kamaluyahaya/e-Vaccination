import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:evaccinations/screen/admin/login.dart';
import 'package:evaccinations/screen/splash.dart';

import 'constant/constant.dart';
import 'menu.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

final TextStyle myTextStyle = TextStyle(fontSize: 10.0);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData myTheme = ThemeData(
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 10),
        bodySmall: TextStyle(fontSize: 14),
        bodyMedium: TextStyle(fontSize: 12),
      ),
      primarySwatch: Colors.blue,
      fontFamily: "Regular",
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eVaccination',
      theme: myTheme,
      home: AnimatedSplashScreen(
        splash: Splash(),
        splashIconSize: 800.0,
        backgroundColor: kWhite,
        nextScreen: const Menu(),
        splashTransition: SplashTransition.scaleTransition,
      ),
    );
  }
}
