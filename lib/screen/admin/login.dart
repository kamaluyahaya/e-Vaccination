import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:evaccinations/component/inputs.dart';
import 'package:evaccinations/constant/constant.dart';
import 'package:evaccinations/screen/admin/navigation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../component/double_click_close.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  bool _processing = false;
  bool isLoading = false;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool ActiveConnection = false;
  String T = "";

  login() async {
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
          "request": "ADMIN LOGIN",
          "username": username.text,
          "password": password.text,
        });

        List data = jsonDecode(res.body);
        if (data.isEmpty) {
          setState(() {
            isLoading = false;
          });
          !isLoading
              ? Navigator.of(context, rootNavigator: true).pop('dialog')
              : _showDialog();
          Toast.show("Incorrect login Details",
              duration: Toast.lengthShort, gravity: Toast.bottom);
          password.clear();
        } else {
          if (res.statusCode == 200) {
            SharedPreferences pred = await SharedPreferences.getInstance();

            Navigator.of(context, rootNavigator: true).pop('dialog');
            Toast.show("Login successfully",
                duration: Toast.lengthShort, gravity: Toast.bottom);

            setState(() {
              // transactionData = jsonDecode(res.body);
              pred.setString("name", data[0]['name']);
              pred.setString("id", data[0]['admin_id']);
              pred.setString("email", data[0]['email']);
              pred.setString("username", data[0]['username']);
            });

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Prescriber_nav()));
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

  @override
  void initState() {
    super.initState();
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
          title: Text(
            "M-Prescription System",
          ),
          backgroundColor: Colors.indigo,
        ),
        body: DoubleClick(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          sizedBox,
                          sizedBox,
                          sizedBox,
                          Image.asset(
                            "img/admin.jpg",
                            width: 150,
                          ),
                        ],
                      )),
                      Divider(),
                      Container(
                        child: Text(
                          "Prescriber record",
                          style: TextStyle(fontSize: 20.0, fontFamily: "Bold"),
                        ),
                      ),
                      Text("Secure Prescriber Login credentials"),
                      sizedBox,
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, bottom: 15.0, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 20.0, fontFamily: "Bold"),
                                ),
                              ),
                              Divider(),
                              Inputs(
                                icon: Icon(Icons.person_outline_outlined),
                                hint: "Enter Username",
                                obsecure: false,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Username is required";
                                },
                                keyboardType: TextInputType.visiblePassword,
                                controller: username,
                              ),
                              sizedBox,
                              Inputs(
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Password is required";
                                },
                                controller: password,
                                hint: "Enter Password",
                                icon: Icon(Icons.lock_clock_outlined),
                                obsecure: true,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              sizedBox,
                            ],
                          ),
                        ),
                      ),
                      sizedBox,
                      Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "Forgot password",
                            style: TextStyle(
                                color: kDefault, fontWeight: FontWeight.bold),
                          )),
                      sizedBox,
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: kDefault,
                                borderRadius: BorderRadius.circular(40)),
                            width: MediaQuery.of(context).size.width,
                            child: OutlinedButton(
                                onPressed: () {
                                  // if (_formKey.currentState!.validate()) {
                                  //   Navigator.of(context).pushReplacement(
                                  //       MaterialPageRoute(
                                  //           builder: (contex) => Navigation()));
                                  // }
                                  login();
                                },
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide.none),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.login_outlined,
                                      color: kWhite,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "Log in",
                                      style: TextStyle(
                                          color: kWhite, fontSize: 20),
                                    ),
                                  ],
                                ))),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class RecordOfficer extends StatefulWidget {
  const RecordOfficer({Key? key}) : super(key: key);

  @override
  State<RecordOfficer> createState() => _RecordOfficerState();
}

class _RecordOfficerState extends State<RecordOfficer> {
  final _formKey = GlobalKey<FormState>();

  bool _processing = false;
  bool isLoading = false;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool ActiveConnection = false;
  String T = "";

  login() async {
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
          "request": "RECORD OFFICER",
          "username": username.text,
          "password": password.text,
        });

        List data = jsonDecode(res.body);
        if (data.isEmpty) {
          setState(() {
            isLoading = false;
          });
          !isLoading
              ? Navigator.of(context, rootNavigator: true).pop('dialog')
              : _showDialog();
          Toast.show("Incorrect login Details",
              duration: Toast.lengthShort, gravity: Toast.bottom);
          password.clear();
        } else {
          if (res.statusCode == 200) {
            SharedPreferences pred = await SharedPreferences.getInstance();

            Navigator.of(context, rootNavigator: true).pop('dialog');
            Toast.show("Login successfully",
                duration: Toast.lengthShort, gravity: Toast.bottom);

            setState(() {
              // transactionData = jsonDecode(res.body);
              pred.setString("record_name", data[0]['name']);
              pred.setString("record_id", data[0]['record_id']);
              pred.setString("record_email", data[0]['email']);
              pred.setString("record_username", data[0]['username']);
            });

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DoubleClick(child: RecordOfficerDash())));
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

  @override
  void initState() {
    super.initState();
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
          title: Text(
            "eVaccination login",
          ),
          backgroundColor: Colors.indigo,
        ),
        body: DoubleClick(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "img/v3.png",
                            // width: 150,
                          ),
                        ],
                      )),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                "User Login",
                                style: TextStyle(
                                    fontSize: 20.0, fontFamily: "Bold"),
                              ),
                            ),
                            Text("Secure Prescriber Login credentials"),
                            sizedBox,
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, bottom: 15.0, right: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 20.0, fontFamily: "Bold"),
                                      ),
                                    ),
                                    Divider(),
                                    Inputs(
                                      icon: Icon(Icons.person_outline_outlined),
                                      hint: "Enter Username",
                                      obsecure: false,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "Username is required";
                                      },
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: username,
                                    ),
                                    sizedBox,
                                    Inputs(
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "Password is required";
                                      },
                                      controller: password,
                                      hint: "Enter Password",
                                      icon: Icon(Icons.lock_clock_outlined),
                                      obsecure: true,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                    ),
                                    sizedBox,
                                  ],
                                ),
                              ),
                            ),
                            sizedBox,
                            Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "Forgot password",
                                  style: TextStyle(
                                      color: kDefault,
                                      fontWeight: FontWeight.bold),
                                )),
                            sizedBox,
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: kDefault,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: MediaQuery.of(context).size.width,
                                  child: OutlinedButton(
                                      onPressed: () {
                                        login();
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide.none),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.login_outlined,
                                            color: kWhite,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            "Log in",
                                            style: TextStyle(
                                                color: kWhite, fontSize: 20),
                                          ),
                                        ],
                                      ))),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
