import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sweetalert/sweetalert.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../../component/adminContainer.dart';
import '../../component/defaultAppBar.dart';
import '../../component/skelaton.dart';
import '../../component/smallContainer.dart';
import '../../constant/constant.dart';
import 'prescribe.dart';
import 'view-prescription.dart';

class PrescriptionRec extends StatefulWidget {
  final status;
  PrescriptionRec(this.status);

  @override
  State<PrescriptionRec> createState() => _PrescriptionRecState();
}

class _PrescriptionRecState extends State<PrescriptionRec> {
  List patientData = [];
  var id;
  int _counter = 1;
  bool isLoading = false;

  Future<void> delete(String user_id) async {
    ToastContext().init(context);

    setState(() {
      isLoading = true;
    });
    try {
      final res = await http.post(Uri.parse(myurl),
          body: {"request": "DELETE CAR", "id": user_id});
      setState(() {
        isLoading = false;
      });
      !isLoading ? print("object") : _showDialog();

      showAlertSuccess();

      getUserData();
    } catch (e) {
      print(e);
    }
  }

  showAlertSuccess() {
    // SweetAlert.show(
    //   context,
    //   style: SweetAlertStyle.success,
    //   title: "Passenger deleted successfully",
    //   subtitle: "You have deleted passenger record successfully",
    // );
  }

  Future<List> getUserData() async {
    // SharedPreferences pred = await SharedPreferences.getInstance();
    try {
      var res = await http
          .post(Uri.parse(myurl), body: {"request": "FETCH ALL PRESCRIPTION"});

      setState(() {
        patientData = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
    return patientData;
  }

  void initState() {
    getUserData();
    profile();
    // print(patientData);
    super.initState();
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
              Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }

  String? name;
  profile() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      name = pred.getString("name");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
          // centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              widget.status == false
                  ? IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        size: 18,
                        Icons.arrow_back_ios_new_outlined,
                      ),
                      color: kBlue)
                  : Container(),
              SizedBox(
                width: 20,
              ),
              Text(
                "M-Prescription system",
                style: TextStyle(color: kBlue, fontSize: 17),
              ),
            ],
          )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: getUserData(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                var myData = snapshot.data;
                if (myData == null) {
                  return Scaffold(
                    body: ShowSkelaton(),
                  );
                } else {
                  return myData.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Pending",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: kRed),
                                    ),
                                    Text(
                                      "Prescriptions",
                                      style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontFamily: "Medium",
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: patientData.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ListContainer1(
                                      // iconPressed: () {
                                      // showAlertDialog(context);
                                      // },
                                      dates: "${patientData[index]['email']}",
                                      departure:
                                          "${patientData[index]['gender']}",
                                      driver_name:
                                          "${patientData[index]['age']}",
                                      destination:
                                          "${patientData[index]['address']}",
                                      license_no:
                                          "${patientData[index]['disability']}",
                                      counter: index + 1,
                                      view: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    ViewPrescription(
                                                        patientData[index]
                                                            ['p_id']))));
                                      },
                                      prescribe: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    Prescription(
                                                        patientData[index]
                                                            ['p_id']))));
                                      },

                                      onPressed: () {
                                        // showAlertDialog(context);
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         Payment(transactionData[index]['id'])));
                                      },

                                      title: patientData[index]['name'],
                                      subtitle: patientData[index]['name'],
                                    );
                                  }),
                            ],
                          ),
                        )
                      : Center(child: Text("No Prescription Records"));
                }
              }),
        ),
      ),
    );
  }
}
