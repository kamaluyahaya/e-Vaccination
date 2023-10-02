import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:evaccinations/component/defaultAppBar.dart';
import 'package:evaccinations/component/inputs.dart';
import 'package:evaccinations/component/subHead.dart';
import 'package:evaccinations/screen/admin/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../../constant/constant.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  State<AddPatient> createState() => _Addevaccinationstate();
}

class _Addevaccinationstate extends State<AddPatient> {
  final _formKey = GlobalKey<FormState>();
  List<String> items = ["Select", "Male", "Female", "Others"];
  String? selected = "Select";
  bool isLoading = false;
  bool _processing = false;
  TextEditingController fullname = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController gender = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController nationality = new TextEditingController();

  showAlertDialog(BuildContext context) {
    Widget okBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("Okay"),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Status"),
      content: Text("Registration Successfully"),
      actions: [
        okBtn,
      ],
    );

    //show the dialog alert
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  registerPatient() async {
    ToastContext().init(context);

    if (_formKey.currentState!.validate()) {
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
          "request": "ADD PATIENT",
          "name": fullname.text,
          "phone": phone.text,
          "gender": selected,
          "address": address.text,
          "state": state.text,
          "nationality": nationality.text,
        });

        if (jsonDecode(res.body) == "exits") {
          setState(() {
            isLoading = false;
          });
          !isLoading ? Navigator.of(context).pop('dialog') : _showDialog();
          Toast.show("Patient record already exit, pls try again",
              duration: Toast.lengthShort, gravity: Toast.bottom);
          _actionsDialog(
              Icons.cancel_outlined, Colors.red, "Record is Already exist!");
        } else {
          if (jsonDecode(res.body) == "success") {
            setState(() {
              isLoading = false;
            });
            !isLoading ? Navigator.of(context).pop('dialog') : _showDialog();
            setState(() {
              isLoading = true;
            });
            Toast.show("successfully",
                duration: Toast.lengthShort, gravity: Toast.bottom);

            showAlertDialog(context);
            // reg_no.clear();
            // password.clear();
          } else {
            Toast.show("Error occured pls try again!",
                duration: Toast.lengthShort, gravity: Toast.bottom);
          }
        }
      } else {
        _Connectivity();
      }
      setState(() {
        _processing = false;
      });
    }
  }

  String? name;
  profile() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      name = pred.getString("name");
    });
  }

  @override
  void initState() {
    super.initState();
    profile();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kDefault,
        title: DefaultAppBar(
          txt: "$name",
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  SubHeader(
                    title: "Register new Patient",
                    icon: Icons.person_add_alt_1_outlined,
                  ),
                  sizedBox,
                  Inputs(
                    obsecure: false,
                    hint: "Full name",
                    controller: fullname,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Full name is required";
                      }
                    },
                    icon: Icon(Icons.person_add_alt_1_outlined),
                  ),
                  sizedBox,
                  Inputs(
                    obsecure: false,
                    hint: "Mobile number",
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Mobile number is required";
                      }
                    },
                    icon: Icon(
                      Icons.phone_android_outlined,
                    ),
                  ),
                  sizedBox,
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: kDefault,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            icon: Icon(Icons.person_search_outlined),
                          ),
                          value: selected,
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ))
                              .toList(),
                          onChanged: (item) => setState(() {
                                selected = item;
                              })),
                    ),
                  ),
                  sizedBox,
                  Inputs(
                    obsecure: false,
                    hint: "Address",
                    controller: address,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Address is required";
                      }
                    },
                    icon: Icon(
                      Icons.contact_mail_outlined,
                    ),
                  ),
                  sizedBox,
                  Inputs(
                    obsecure: false,
                    hint: "State of Origin",
                    controller: state,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "State is required";
                      }
                    },
                    icon: Icon(Icons.person_add_alt_1_outlined),
                  ),
                  sizedBox,
                  Inputs(
                    obsecure: false,
                    hint: "Nationality",
                    controller: nationality,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Nationality is required";
                      }
                    },
                    icon: Icon(Icons.person_add_alt_1_outlined),
                  ),
                  sizedBox,
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(40)),
                      width: MediaQuery.of(context).size.width,
                      child: OutlinedButton(
                          onPressed: () {
                            // if (_formKey.currentState!.validate()) {
                            //   Navigator.of(context).pushReplacement(
                            //       MaterialPageRoute(
                            //           builder: (contex) => Navigation()));
                            // }
                            registerPatient();
                          },
                          style:
                              OutlinedButton.styleFrom(side: BorderSide.none),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add_alt_1_outlined,
                                color: kWhite,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Register",
                                style: TextStyle(color: kWhite, fontSize: 20),
                              ),
                            ],
                          ))),
                  sizedBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
