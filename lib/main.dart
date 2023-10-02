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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M-Prescription',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 12.0),
          bodyText2: TextStyle(fontSize: 12.0),
          headline1: TextStyle(fontSize: 20.0),
          // add more styles as needed
        ),
        primarySwatch: Colors.blue,
        fontFamily: "Regular",
      ),
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
