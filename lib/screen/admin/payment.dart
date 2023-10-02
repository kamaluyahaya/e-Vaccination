import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../../component/defaultAppBar.dart';
import '../../component/inputs.dart';
import '../../component/skelaton.dart';
import '../../component/subHead.dart';
import '../../constant/constant.dart';
import 'generate-invoice.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  List courseData = [];
  bool _processing = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController amount = new TextEditingController();
  TextEditingController card_no = new TextEditingController();
  TextEditingController cvv = new TextEditingController();
  TextEditingController expire_date = new TextEditingController();

  pay() async {
    ToastContext().init(context);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _processing = true;
      });

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
          "request": "PAYMENT",
          "card_no": card_no.text,
          "cvv": cvv.text,
          "expire_date": expire_date.text,
          "amount": amount.text,
        });

        if (jsonDecode(res.body) == "failed") {
          setState(() {
            isLoading = false;
          });
          !isLoading
              ? Navigator.of(context, rootNavigator: true).pop('dialog')
              : _showDialog();
          Toast.show("Incorrect login Details",
              duration: Toast.lengthShort, gravity: Toast.bottom);
        } else {
          if (jsonDecode(res.body) == "success") {
            SharedPreferences pred = await SharedPreferences.getInstance();

            Navigator.of(context, rootNavigator: true).pop('dialog');

            Toast.show("Payment Successfully",
                duration: Toast.lengthShort, gravity: Toast.bottom);

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => GenerateInvoice()));
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

  showAlertDialog(
    BuildContext context,
  ) {
    Widget okBtn = TextButton(
      onPressed: () async {
        pay();
        Navigator.of(context).pop();
      },
      child: Text("Continue"),
    );

    Widget noBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("Cancel"),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Payment confirmation"),
      content: Text("No refundable after payment\nDo you want to Continue?"),
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

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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

  String? name;
  profile() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      name = pred.getString("name");
    });
  }

  void initState() {
    // getUserData();
    // datas();
    profile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kDefault,
          title: DefaultAppBar(
            txt: "Payment side",
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                SizedBox(
                  height: 5.0,
                ),
                SubHeader(title: "Payment Site", icon: Icons.payment_outlined),
                sizedBox,
                Image(
                  image: AssetImage("img/payment.png"),
                ),
                name == null
                    ? ShowSkelaton()
                    : GestureDetector(
                        onTap: () =>
                            FocusManager.instance.primaryFocus!.unfocus(),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text("${courseData[0]['level']}"),
                                  Inputs(
                                      icon: Icon(Icons.payment_outlined),
                                      hint: "Card number",
                                      obsecure: false,
                                      keyboardType: TextInputType.number,
                                      controller: card_no,
                                      validator: (value) {
                                        if (value.isEmpty || value.length < 8) {
                                          return "Card number is invalid";
                                        }
                                      }),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          TextFormField(
                                              cursorHeight: 20,
                                              controller: cvv,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    3) // only allow 3 digit number
                                              ],
                                              decoration: InputDecoration(
                                                labelText: "CVV number",
                                                border: OutlineInputBorder(),
                                                prefixIcon: Icon(
                                                    Icons.payment_outlined),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Inputs(
                                      icon: Icon(Icons.payment_outlined),
                                      hint: "Expire date",
                                      obsecure: false,
                                      keyboardType: TextInputType.datetime,
                                      controller: expire_date,
                                      validator: (value) {
                                        if (value.isEmpty ||
                                            !value.contains("/")) {
                                          return "Pls Check card expire date";
                                        }
                                      }),
                                  SizedBox(
                                    height: 10.0,
                                  ),

                                  Inputs(
                                      icon: Icon(Icons.payment_outlined),
                                      hint: "Amount to Pay",
                                      obsecure: false,
                                      keyboardType: TextInputType.number,
                                      controller: amount,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Amount to pay ";
                                        }
                                      }),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  // TextFormField(
                                  //     cursorHeight: 20,
                                  //     keyboardType: TextInputType.number,
                                  //     controller: TextEditingController()..text = "N550",
                                  //     readOnly: true,
                                  //     decoration: InputDecoration(
                                  //       labelText: "Price to pay",
                                  //       border: OutlineInputBorder(),
                                  //       prefixIcon: Icon(Icons.payment),
                                  //     )),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                    ),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide.none),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          showAlertDialog(
                                            context,
                                          );
                                        }
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.payment_outlined,
                                            color: kWhite,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            "Pay NOW",
                                            style: TextStyle(
                                              color: kWhite,
                                              fontFamily: "RobotoBold",
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ])),
        ));
  }
}
