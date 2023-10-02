import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'component/defaultButton.dart';
import 'constant/constant.dart';
import 'screen/admin/login.dart';

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
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          const SizedBox(
            height: 70,
          ),
          Center(
              child: Column(
            children: [
              Text("eVaccination System",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                "Development of an Android app for an eVaccination system",
              )
            ],
          )),
          SizedBox(
            height: 110,
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
          SizedBox(
            height: 80,
          ),
          // Text("Chatbot for Banking"),
          // Image.asset("assets/images/nbte.png"),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                DefaultButton(
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (contex) => RecordOfficer()));
                  },
                  color: Colors.blue,
                  title: "Patient Login",
                ),
                sizedBox,
                DefaultButton(
                    onPress: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (contex) => Login()));
                    },
                    title: "Admin Login",
                    color: Color.fromARGB(255, 47, 62, 149)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
