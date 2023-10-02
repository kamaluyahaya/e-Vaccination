import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../component/defaultAppBar.dart';
import '../../component/skelaton.dart';
import '../../component/subHead.dart';
import '../../constant/constant.dart';
import 'prescribe.dart';

class ViewPrescription extends StatefulWidget {
  final patient_id;
  ViewPrescription(this.patient_id);

  @override
  State<ViewPrescription> createState() => _ViewPrescriptionState();
}

class _ViewPrescriptionState extends State<ViewPrescription> {
  var name, email, username;
  profile() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      name = pred.getString("name");
      email = pred.getString("email");
      username = pred.getString("username");
    });
  }

  List patientData = [];
  Future<List> getUserData() async {
    // SharedPreferences pred = await SharedPreferences.getInstance();
    try {
      // transactionData = jsonDecode(res.body);
      // pred.setString("course", transactionData[0]['course']);
      // pred.setString("semester", transactionData[0]['semester']);
      // pred.setString("level", transactionData[0]['level']);
      // id = pred.getString("id");
      var res = await http.post(Uri.parse(myurl),
          body: {"request": "FETCH PRESCRIPTION", "id": widget.patient_id});

      setState(() {
        patientData = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
    return patientData;
  }

  @override
  void initState() {
    super.initState();
    profile();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 244, 244),
        appBar: AppBar(
            // centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      size: 18,
                      Icons.arrow_back_ios_new_outlined,
                    ),
                    color: kBlue),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "View Prescription",
                  style: TextStyle(color: kBlue, fontSize: 17),
                ),
              ],
            )),
        body: patientData.isEmpty
            ? ShowSkelaton()
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(children: [
                      sizedBox,

                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: kWhite,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                  "http://192.168.43.233/2022-2023-app/prescription/images/${patientData[0]['image']}",
                                ),
                              ),
                              Text(
                                "${patientData[0]['name']}",
                                style:
                                    TextStyle(fontFamily: "Bold", fontSize: 20),
                              ),
                              Text(
                                "(Patient)",
                                style: TextStyle(
                                    fontFamily: "Regular", fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Text(
                      //   "Kangiwa Hospital Prescription",
                      //   style: TextStyle(fontFamily: "Bold", fontSize: 18),
                      // ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        color: kWhite,
                        width: MediaQuery.of(context).size.width,
                        height: 110,
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Name"),
                                          Text(
                                            "${patientData[0]['name']}",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${patientData[0]['gender']}"),
                                          Text(
                                            "Male",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Age"),
                                          Text(
                                            "${patientData[0]['age']} yrs",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // SubHeader(
                      //   title: "My Profile",
                      //   icon: Icons.person_add_alt_1_outlined,
                      // ),
                      // sizedBox,
                      Container(
                        color: kWhite,
                        width: MediaQuery.of(context).size.width,
                        height: 75,
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("City"),
                                          Text(
                                            "${patientData[0]['city']}",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Address"),
                                          Text(
                                            "${patientData[0]['address']}",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ),
                      // sizedBox,
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        color: kWhite,
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Email"),
                                          Text(
                                            "${patientData[0]['email']}",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Blood group"),
                                          Text(
                                            "${patientData[0]['blood']}",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Disability"),
                                          Text(
                                            "${patientData[0]['disability']}",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ),
                      sizedBox,
                      Container(
                          width: MediaQuery.of(context).size.width / 1.4,
                          height: 50,
                          decoration: BoxDecoration(
                              color: kDefault,
                              borderRadius: BorderRadius.circular(50)),
                          child: Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) => Prescription(
                                                patientData[0]['p_id']))));
                                  },
                                  child: Text("Prescribe patient",
                                      style: TextStyle(
                                        color: kWhite,
                                      ))),
                            ],
                          )),

                      Text("The above patient record Prescribe patient ",
                          style: TextStyle(
                            color: kRed,
                          )),
                    ])),
              ));
  }
}
