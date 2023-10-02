import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_plus/dropdown_plus.dart';
// import '../../component/bottom.dart';
import '../../component/bottom.dart';
import '../../component/defaultAppBar.dart';
import '../../component/inputs.dart';
import '../../component/skelaton.dart';
import '../../constant/constant.dart';
import 'navigation.dart';

class Retrieve extends StatefulWidget {
  Retrieve({Key? key}) : super(key: key);

  @override
  State<Retrieve> createState() => _RetrieveState();
}

class _RetrieveState extends State<Retrieve> {
  final _formKey = GlobalKey<FormState>();
  bool _processing = false;

  bool isLoading = false;

  TextEditingController p_id = new TextEditingController();

  showAlertDialog(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: 'Registration successfully!',
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  showResult() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      text: 'No Record found',
      // reverseBtnOrder: true,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  List patientData = [];

  getUserData() async {
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

        var res = await http.post(Uri.parse(myurl), body: {
          "request": "RETRIEVE PATIENT",
          "p_id": p_id.text,
        });

        List data = jsonDecode(res.body);
        if (data.isEmpty) {
          setState(() {
            isLoading = false;
          });
          !isLoading ? print("") : _showDialog();
          Navigator.of(context, rootNavigator: true).pop('dialog');
          showResult();
          p_id.clear();
        } else {
          if (res.statusCode == 200) {
            Navigator.of(context, rootNavigator: true).pop('dialog');

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DisplayRecord(data[0]['p_id'])));
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

  void _Connectivity() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              Icon(Icons.cancel, size: 30.0, color: Colors.deepOrange[200]),
              SizedBox(
                width: 20.0,
              ),
              Text("No internet connection!"),
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
              CircularProgressIndicator(),
              SizedBox(
                width: 25.0,
              ),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var licenseNo = new MaskTextInputFormatter(
    //     mask: '###-###-##',
    //     filter: {"#": RegExp(r'[0-9A-Z]', caseSensitive: false)},
    //     type: MaskAutoCompletionType.lazy);
    return Scaffold(
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
                  "Register patient",
                  style: TextStyle(color: kBlue, fontSize: 17),
                ),
              ],
            )),
        body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: SingleChildScrollView(
                child: Column(children: [
              Form(
                key: _formKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: kWhite,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[200],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Send Prescription",
                                    style: TextStyle(fontFamily: "Bold")),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                // height: MediaQuery.of(context).size.height / 1.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: kWhite,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Inputs(
                                        icon:
                                            Icon(Icons.person_outline_outlined),
                                        controller: p_id,
                                        keyboardType: TextInputType.text,
                                        hint: "Patient Registration no.",
                                        obsecure: false,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Registration no. is required";
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  DefaultBottom(
                                    route: () {
                                      getUserData();
                                    },
                                    title: "Find record",
                                    color: kDefault,
                                    icon: Icons.save_as_outlined,
                                  ),
                                ],
                              ),
                            ),
                            sizedBox,
                            sizedBox,
                            sizedBox,
                            sizedBox,
                          ]),
                    ),
                  ),
                ]),
              )
            ]))));
  }
}

class DisplayRecord extends StatefulWidget {
  final p_id;
  DisplayRecord(this.p_id);

  @override
  State<DisplayRecord> createState() => _DisplayRecordState();
}

class _DisplayRecordState extends State<DisplayRecord> {
  final _formKey = GlobalKey<FormState>();
  bool _processing = false;

  bool isLoading = false;

  // TextEditingController p_id = new TextEditingController();

  showAlertDialog(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: 'Record has sent for prescription!',
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  List patientData = [];

  Future<List> getUserData() async {
    try {
      var res = await http.post(Uri.parse(myurl), body: {
        "request": "FETCH PATIENT",
        "p_id": widget.p_id,
      });

      setState(() {
        patientData = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
    return patientData;
  }

  sendPrescription() async {
    ToastContext().init(context);

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
        "request": "SEND PRESCRIPTION",
        "p_id": widget.p_id,
        // "email": email.text,
        // "username": username.text,
        // "password": password.text,
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
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Send prescription",
                  style: TextStyle(color: kBlue, fontSize: 17),
                ),
              ],
            )),
        body: FutureBuilder(
            future: getUserData(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              var carsData = snapshot.data;
              if (carsData == null) {
                return Scaffold(
                  body: Center(child: ShowSkelaton()),
                );
              } else {
                return carsData.isNotEmpty
                    ? Padding(
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
                                    style: TextStyle(
                                        fontFamily: "Bold", fontSize: 20),
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
                            // height: 110,
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
                                              Text("Registration number"),
                                              Text(
                                                "${patientData[0]['p_id']}",
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
                                              Text(
                                                  "${patientData[0]['gender']}"),
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
                                              Text("Phone number"),
                                              Text(
                                                "${patientData[0]['phone']}",
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
                                        sendPrescription();
                                      },
                                      child: Text("Send Prescription",
                                          style: TextStyle(
                                            color: kWhite,
                                          ))),
                                ],
                              )),

                          // Text("The above patient record Prescribe patient ",
                          //     style: TextStyle(
                          //       color: kRed,
                          //     )),
                        ]))
                    : Center(child: Text("No Record found"));
              }
            }));
  }
}
