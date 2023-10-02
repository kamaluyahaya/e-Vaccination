import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:evaccinations/screen/admin/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../component/defaultAppBar.dart';
import '../../component/inputs.dart';
import '../../component/skelaton.dart';
import '../../component/subHead.dart';
import '../../constant/constant.dart';

class Prescription extends StatefulWidget {
  final patient_id;
  Prescription(this.patient_id);

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  TextEditingController medicine = new TextEditingController();
  TextEditingController dosage = new TextEditingController();
  TextEditingController duration = new TextEditingController();
  TextEditingController instruction = new TextEditingController();

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
    try {
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

  bool isLoading = false;
  bool _processing = false;
  final _formKey = GlobalKey<FormState>();
  showAlertDialog(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.confirm,
          text: 'Do want to proceed?',
          confirmBtnText: 'Yes',
          cancelBtnText: 'No',
          backgroundColor: kDefault,
          onConfirmBtnTap: () {
            // CoolAlert.show(
            //   context: context,
            //   type: CoolAlertType.success,
            //   text:
            //       'Transaction completed successfully!',
            //   autoCloseDuration:
            //       const Duration(seconds: 2),
            // );
            // print("SUCCESS");

            prescribe();
          },
          confirmBtnColor: Colors.green);
    }
  }

  prescribe() async {
    var connectedResult = await Connectivity().checkConnectivity();
    if (connectedResult == ConnectivityResult.mobile ||
        connectedResult == ConnectivityResult.wifi) {
      setState(() {
        isLoading = true;
      });
      isLoading
          ? _showDialog()
          : Navigator.of(context, rootNavigator: true).pop('dialog');
      Timer(Duration(seconds: 3), () {});

      final res = await http.post(Uri.parse(myurl), body: {
        "request": "PRESCRIBE",
        "p_id": widget.patient_id,
        "medicine": medicine.text,
        "dosage": dosage.text,
        "duration": duration.text,
        "instruction": instruction.text
      });

      if (jsonDecode(res.body) == "exits") {
        setState(() {
          isLoading = false;
        });
        !isLoading ? Navigator.of(context).pop('dialog') : _showDialog();
        // Toast.show("Patient record already exit, pls try again",
        //     duration: Toast.lengthShort, gravity: Toast.bottom);

        CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          text: 'Record has already sent!',
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        if (jsonDecode(res.body) == "success") {
          setState(() {
            isLoading = false;
          });
          !isLoading ? Navigator.of(context).pop('dialog') : _showDialog();
          setState(() {
            isLoading = true;
          });

          // showAlertDialog(context);
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: 'Success',
              autoCloseDuration: const Duration(seconds: 3));
          Timer(Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => PrescriberDash())));
          });
          // reg_no.clear();
          // password.clear();
        } else {}
      }
    } else {
      _Connectivity();
    }
    setState(() {
      _processing = false;
    });
  }

  void _Connectivity() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              new Icon(Icons.cancel, size: 30.0, color: Colors.deepOrange[200]),
              SizedBox(
                width: 20.0,
              ),
              new Text("No Internet Connection!"),
            ],
          ),
        );
      },
    );
  }

  void _actionsDialog(icon, color, title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              new Icon(icon, size: 30.0, color: color),
              SizedBox(
                width: 20.0,
              ),
              new Text(title),
            ],
          ),
        );
      },
    );
  }

  void _Validation(String txt, icons) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              new Icon(icons, size: 30.0, color: Colors.deepOrange[200]),
              SizedBox(
                width: 20.0,
              ),
              new Text(txt),
            ],
          ),
        );
      },
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              new CircularProgressIndicator(),
              SizedBox(
                width: 25.0,
              ),
              new Text("Please wait..."),
            ],
          ),
        );
      },
    );
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
                  "Prescribe patient",
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
                                  "https://aksoft.com.ng/flutter_apps/prescription/images/${patientData[0]['image']}",
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
                        // width: MediaQuery.of(context).size.width,
                        // height: 110,
                        child: Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  Inputs(
                                    icon: Icon(
                                        Icons.medical_information_outlined),
                                    hint: "Medication name",
                                    obsecure: false,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Medication is required";
                                    },
                                    keyboardType: TextInputType.visiblePassword,
                                    controller: medicine,
                                  ),
                                  sizedBox,
                                  Inputs(
                                    icon: Icon(
                                        Icons.medical_information_outlined),
                                    hint: "Dosage Instruction",
                                    obsecure: false,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Dosage is required";
                                    },
                                    keyboardType: TextInputType.name,
                                    controller: dosage,
                                  ),
                                  sizedBox,
                                  Inputs(
                                    icon: Icon(
                                        Icons.medical_information_outlined),
                                    hint: "Duration of Prescription",
                                    obsecure: false,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Duration is required";
                                    },
                                    keyboardType: TextInputType.visiblePassword,
                                    controller: duration,
                                  ),
                                  sizedBox,
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextFormField(
                                        keyboardType: TextInputType.name,
                                        controller: instruction,
                                        // validator: validator,
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return "Instruction is required";
                                        },
                                        // obscureText: obsecure,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          labelText: "Instructions",
                                          border: OutlineInputBorder(),
                                          prefixIcon:
                                              Icon(Icons.warning_outlined),
                                        )),
                                  ),
                                  sizedBox,
                                ]),
                          ),
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
                                    showAlertDialog(context);
                                  },
                                  child: Text("Prescribe Now",
                                      style: TextStyle(
                                        color: kWhite,
                                      ))),
                            ],
                          )),
                      SizedBox(
                        height: 10.0,
                      ),

                      Container(
                        color: kWhite,
                        width: MediaQuery.of(context).size.width,
                        height: 75,
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: []),
                        ),
                      ),
                      // sizedBox,
                      SizedBox(
                        height: 10.0,
                      ),

                      Text("The above patient record Prescribe patient ",
                          style: TextStyle(
                            color: kRed,
                          )),
                    ])),
              ));
  }
}
