import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:evaccinations/component/defaultAppBar.dart';
import 'package:evaccinations/component/smallContainer.dart';
import 'package:evaccinations/constant/constant.dart';
import 'package:evaccinations/screen/admin/add_patient.dart';
import 'package:evaccinations/screen/admin/add_staff.dart';
import 'package:evaccinations/screen/admin/login.dart';
import 'package:evaccinations/screen/admin/patient-record.dart';
import 'package:evaccinations/screen/admin/payment-record.dart';
import 'package:evaccinations/screen/admin/payment.dart';
import 'package:evaccinations/screen/admin/profile.dart';
import 'package:evaccinations/screen/admin/staff-record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../component/myContainer.dart';
import '../../menu.dart';
import 'addPatient.dart';
import 'prescription-record.dart';
import 'records.dart';
import 'retreive.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  showAlertDialog(
    BuildContext context,
  ) {
    Widget okBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop('dialog');
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      },
      child: Text("Yes"),
    );

    Widget noBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop('dialog');
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => CleanerRecord()));
      },
      child: Text("No"),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Status"),
      content: Text("Confirm if you want to exist?"),
      actions: [
        okBtn,
        noBtn,
      ],
    );

    //show the dialog alert
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: kWhiteSmoke,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: Offset(3, 2),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ]),
                    height: 110,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(
                                    "img/pa4.jpg",
                                  ),
                                )),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Profile()));
                              },
                              child: Text("My profile")),
                        ],
                      ),
                    ),
                  ),
                  sizedBox,
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "DASHBOARD",
                      style: TextStyle(
                          color: kDefault,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallContainer(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddPatient()));
                        },
                        txt: "Add evaccinations",
                        icon: Icons.person_add_alt_1_outlined,
                      ),
                      SmallContainer(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PatientRecord()));
                          },
                          txt: "Manage\nevaccinations",
                          icon: Icons.people_outline_outlined)
                    ],
                  ),
                  sizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallContainer(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddStaff()));
                          },
                          txt: "Staffs",
                          icon: Icons.people_outline_outlined),
                      SmallContainer(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PaymentRecord()));
                          },
                          txt: "Transactions",
                          icon: Icons.file_present_outlined),
                    ],
                  ),
                  sizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallContainer(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Payment()));
                          },
                          txt: "Payment",
                          icon: Icons.payment_outlined),
                      SmallContainer(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StaffRecord()));
                          },
                          txt: "Hospitals\nRecords",
                          icon: Icons.local_hospital_outlined),
                    ],
                  ),
                  sizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallContainer(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Profile()));
                          },
                          txt: "My\nProfile",
                          icon: Icons.lock_outline_rounded),
                      SmallContainer(
                          onTap: () => showAlertDialog(context),
                          txt: "Log out",
                          icon: Icons.logout_outlined)
                    ],
                  ),
                  sizedBox,
                  Text("Dashboard"),
                ],
              ),
            ),
          ),
        ));
  }
}

class PrescriberDash extends StatefulWidget {
  const PrescriberDash({Key? key}) : super(key: key);

  @override
  State<PrescriberDash> createState() => _PrescriberDashState();
}

class _PrescriberDashState extends State<PrescriberDash> {
  showAlertDialog(
    BuildContext context,
  ) {
    Widget okBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop('dialog');
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      },
      child: Text("Yes"),
    );

    Widget noBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop('dialog');
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => CleanerRecord()));
      },
      child: Text("No"),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Status"),
      content: Text("Confirm if you want to exist?"),
      actions: [
        okBtn,
        noBtn,
      ],
    );

    //show the dialog alert
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  var now, formattedDate;
  dateUpdate() {
    now = new DateTime.now();
    var formatter = DateFormat.yMMMMd('en_US');
    formattedDate = formatter.format(now);
  }

  String? name;
  profile() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      name = pred.getString("name");
    });
  }

  List prescriptionRecord = [];
  List prescriptionList = [];
  Future<List> getUserData() async {
    try {
      var res = await http.post(Uri.parse(myurl), body: {
        "request": "COUNT PRESCRIPTION RECORD",
      });

      setState(() {
        prescriptionRecord = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
    return prescriptionRecord;
  }

  Future<List> prescribe() async {
    try {
      var res = await http.post(Uri.parse(myurl), body: {
        "request": "COUNT ALL PRESCRIPTION",
      });

      setState(() {
        prescriptionList = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
    return prescriptionList;
  }

  @override
  void initState() {
    super.initState();
    profile();
    dateUpdate();
    setState(() {
      getUserData();
      prescribe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: kWhite,
          title: DefaultAppBar(
            txt: "$name",
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              // height: 500,
              color: Color.fromARGB(255, 248, 247, 247),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: kWhiteSmoke,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: Offset(3, 2),
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                ),
                              ]),
                          height: 110,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 150,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "img/pa4.jpg",
                                        ),
                                      )),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Profile()));
                                    },
                                    child: Text("My profile")),
                              ],
                            ),
                          ),
                        ),
                        sizedBox,
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "DASHBOARD",
                            style: TextStyle(
                                color: kDefault,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        SmallContainer(
                          status: "true",
                          numbers: prescriptionList.isEmpty
                              ? "0"
                              : prescriptionList[0]['count(*)'],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PrescriptionRec(false)));
                          },
                          txt: "New Prescription",
                          icon: Icons.person_add_alt_1_outlined,
                        ),
                        sizedBox,
                        SmallContainer(
                          status: "true",
                          numbers: prescriptionRecord.isEmpty
                              ? "0"
                              : prescriptionRecord[0]['count(*)'],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Record(false)));
                          },
                          txt: "Prescription records",
                          icon: Icons.person_add_alt_1_outlined,
                        ),
                        sizedBox,
                        SmallContainer(
                          onTap: () => showAlertDialog(context),
                          txt: "Log out",
                          icon: Icons.person_add_alt_1_outlined,
                        ),
                        sizedBox,
                        Container(
                            color: Color.fromARGB(255, 242, 248, 252),
                            height: 100,
                            width: MediaQuery.of(context).size.height,
                            child: Center(
                                child: Text("Today's date $formattedDate"))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class RecordOfficerDash extends StatefulWidget {
  const RecordOfficerDash({Key? key}) : super(key: key);

  @override
  State<RecordOfficerDash> createState() => _RecordOfficerDashState();
}

class _RecordOfficerDashState extends State<RecordOfficerDash> {
  showAlertDialog(
    BuildContext context,
  ) {
    Widget okBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop('dialog');
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Menu()));
      },
      child: Text("Yes"),
    );

    Widget noBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop('dialog');
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => CleanerRecord()));
      },
      child: Text("No"),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Status"),
      content: Text("Confirm if you want to exist?"),
      actions: [
        okBtn,
        noBtn,
      ],
    );

    //show the dialog alert
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  var now, formattedDate;
  dateUpdate() {
    now = new DateTime.now();
    var formatter = DateFormat.yMMMMd('en_US');
    formattedDate = formatter.format(now);
  }

  String? name;
  profile() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      name = pred.getString("name");
    });
  }

  List patientList = [];
  List prescriptionList = [];
  Future<List> getUserData() async {
    try {
      var res = await http.post(Uri.parse(myurl), body: {
        "request": "COUNT ALL PATIENT",
      });

      setState(() {
        patientList = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
    return patientList;
  }

  Future<List> prescribe() async {
    try {
      var res = await http.post(Uri.parse(myurl), body: {
        "request": "COUNT ALL PRESCRIPTION",
      });

      setState(() {
        prescriptionList = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
    return prescriptionList;
  }

  @override
  void initState() {
    super.initState();
    profile();
    getUserData();
    prescribe();
    dateUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: kWhite,
          title: DefaultAppBar(
            txt: "$name",
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              // height: 500,
              color: Color.fromARGB(255, 248, 247, 247),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Image.asset(
                          "img/officer1.jpg",
                          width: 200,
                        ),
                        //
                        sizedBox,
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "DASHBOARD",
                            style: TextStyle(
                                color: kDefault,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        SmallContainer(
                          status: "true",
                          numbers: patientList.isEmpty
                              ? "0"
                              : patientList[0]['count(*)'],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Add_Patient()));
                          },
                          txt: "Register patient",
                          icon: Icons.person_add_alt_1_outlined,
                        ),
                        sizedBox,
                        SmallContainer(
                          status: "true",
                          numbers: prescriptionList.isEmpty
                              ? "0"
                              : patientList[0]['count(*)'],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Retrieve()));
                          },
                          txt: "Send prescription",
                          icon: Icons.person_add_alt_1_outlined,
                        ),
                        sizedBox,
                        SmallContainer(
                          onTap: () => showAlertDialog(context),
                          txt: "Log out",
                          icon: Icons.person_add_alt_1_outlined,
                        ),
                        sizedBox,
                        Container(
                            color: Color.fromARGB(255, 242, 248, 252),
                            height: 100,
                            width: MediaQuery.of(context).size.height,
                            child: Center(
                                child: Text("Today's date $formattedDate"))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
