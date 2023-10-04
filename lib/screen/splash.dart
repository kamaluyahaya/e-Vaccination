import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

import '../constant/constant.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
        backgroundColor: kWhite,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sizedBox,
              SizedBox(
                child: Shimmer.fromColors(
                  baseColor: Color.fromARGB(255, 169, 25, 15),
                  highlightColor: Color.fromARGB(255, 238, 223, 87),
                  child: Text(
                    'e-Vaccination Management System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "Bold",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    child: const Image(image: AssetImage("img/v2.webp")),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  sizedBox,
                  sizedBox,
                  SpinKitFadingCircle(
                    color: kDefault,
                  ),
                  sizedBox,
                  Text(
                    "Please wait...",
                    // style: styles,
                  ),
                ],
              ),
              // sizedBox,
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Design By Adamu Said Alkasim - KASU/18/CSC/1006",
                  style: TextStyle(
                      fontSize: 15, fontFamily: "Bold", color: kDefault),
                ),
              ),
              sizedBox,
            ],
          ),
        ));
  }
}
