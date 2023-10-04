import 'dart:async';
import 'dart:convert';

import 'package:evaccinations/component/double_click_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'component/defaultButton.dart';
import 'constant/constant.dart';
import 'screen/admin/login.dart';
import 'screen/admin/user/register.dart';
import 'screen/admin/user/user-login.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: DoubleClick(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  children: [
                    Text("eVaccination System",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                      "Development of an Android app for an eVaccination system",
                    )
                  ],
                ),
              ),
              Container(
                child: Image(
                  image: AssetImage("img/press.jpg"),
                  height: 250,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultButton(
                          onPress: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (contex) => Register()));
                          },
                          color: Colors.blue,
                          title: "Get started",
                          icon: Icons.logout_outlined),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DefaultButton(
                          onPress: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (contex) => UserLogin()));
                          },
                          color: Color.fromARGB(255, 150, 164, 136),
                          title: "Log in",
                          icon: Icons.login_outlined),
                    ),

                    sizedBox,
                    // DefaultButton(
                    //     onPress: () {
                    //       Navigator.of(context).push(
                    //           MaterialPageRoute(builder: (contex) => Login()));
                    //     },
                    //     title: "Admin Login",
                    //     color: Color.fromARGB(255, 47, 62, 149)),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
