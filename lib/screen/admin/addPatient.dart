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
import '../../constant/constant.dart';
import 'navigation.dart';

class Add_Patient extends StatefulWidget {
  Add_Patient({Key? key}) : super(key: key);

  @override
  State<Add_Patient> createState() => _Add_PatientState();
}

class _Add_PatientState extends State<Add_Patient> {
  File? image;
  bool process = false;
  final picker = ImagePicker();

  Future pickGallery() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedImage!.path);
    });
  }

  final _formKey = GlobalKey<FormState>();
  bool processing = false;

  bool isLoading = false;

  TextEditingController name = new TextEditingController();
  TextEditingController age = new TextEditingController();
  TextEditingController gender = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController disability = new TextEditingController();
  TextEditingController blood = new TextEditingController();

  showAlertDialog(BuildContext context) {
    // SweetAlert.show(context,
    //     style: SweetAlertStyle.success,
    //     title: "Registration successfully",
    //     subtitle: "You have added new express car successfully",
    //     onPress: (bool isYes) {
    //   if (isYes) {
    //     Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (context) => Navigation()));
    //   } else {
    //     Navigator.of(context).pop();
    //   }

    //   return false;
    // });

    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: 'Registration successfully!',
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  Future<void> registerUser() async {
    ToastContext().init(context);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        processing = true;
      });

      var connectedResult = await Connectivity().checkConnectivity();
      if (connectedResult == ConnectivityResult.mobile ||
          connectedResult == ConnectivityResult.wifi) {
        setState(() {
          isLoading = true;
        });
        isLoading ? _showDialog() : Navigator.of(context).pop();

        Timer(Duration(seconds: 3), () {});

        final uri = Uri.parse(myurl);
        var request = http.MultipartRequest("POST", uri);
        request.fields['request'] = "ADD PATIENT";
        request.fields['name'] = name.text;
        request.fields['age'] = age.text;
        request.fields['gender'] = gender.text;
        request.fields['city'] = " ";
        request.fields['address'] = address.text;
        request.fields['email'] = email.text;
        request.fields['blood'] = blood.text;
        request.fields['disability'] = " ";

        var pic = await http.MultipartFile.fromPath("car_picture", image!.path);
        request.files.add(pic);

        var response = await request.send();
        if (response.statusCode != 200) {
          setState(() {
            isLoading = false;
          });
          !isLoading ? Navigator.of(context).pop('dialog') : _showDialog();
          Toast.show("Record already exit, pls try again",
              duration: Toast.lengthShort, gravity: Toast.bottom);
          _actionsDialog(
              Icons.cancel_outlined, kRed, "Record is Already exist!");
        } else {
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
          name.clear();
          age.clear();
          gender.clear();
          blood.clear();
          city.clear();
          address.clear();
          disability.clear();
        }
      } else {
        _Connectivity();
      }
      setState(() {
        processing = false;
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
            backgroundColor: Colors.blue,
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
                                child: Text("Personal Information",
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
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 0,
                                      ),
                                      Inputs(
                                        icon:
                                            Icon(Icons.person_outline_outlined),
                                        // keyboardType: TextCapitalization.words,
                                        controller: name,
                                        hint: "Patient name",
                                        obsecure: false,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Name is required";
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Inputs(
                                        icon:
                                            Icon(Icons.person_outline_outlined),
                                        // textCapital: TextCapitalization.none,
                                        hint: "Age.",
                                        controller: age,
                                        // format: licenseNo,
                                        keyboardType: TextInputType.number,
                                        obsecure: false,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Age is required";
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Inputs(
                                        icon:
                                            Icon(Icons.person_outline_outlined),
                                        controller: gender,
                                        keyboardType: TextInputType.text,
                                        hint: "Gender",
                                        obsecure: false,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Gender is required";
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      // Text("Car Picture",
                                      // style: TextStyle(fontSize: 14)),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              pickGallery();
                                            },
                                            child: Row(
                                              children: [
                                                // Icon(Icons.camera_alt_outlined, size: 30),

                                                image == null
                                                    ? Text("Upload picture",
                                                        style: TextStyle(
                                                            color: kRed))
                                                    : Text(
                                                        "Picture Uploaded successful",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Inputs(
                                        icon:
                                            Icon(Icons.person_outline_outlined),
                                        controller: blood,
                                        keyboardType: TextInputType.text,
                                        hint: "Blood Group",
                                        obsecure: false,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Blood group is required";
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.grey[200],
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Contact Information",
                                              style: TextStyle(
                                                  fontFamily: "Bold")),
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          // height: MediaQuery.of(context).size.height / 1.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: kWhite,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                // Inputs(
                                                //   icon: Icon(Icons
                                                //       .person_outline_outlined),
                                                //   controller: city,
                                                //   keyboardType:
                                                //       TextInputType.text,
                                                //   hint: "City",
                                                //   obsecure: false,
                                                //   validator: (value) {
                                                //     if (value.isEmpty) {
                                                //       return "City is required";
                                                //     }
                                                //   },
                                                // ),
                                                // SizedBox(
                                                //   height: 10.0,
                                                // ),
                                                Inputs(
                                                  icon: Icon(Icons
                                                      .person_outline_outlined),
                                                  controller: email,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  hint: "Email",
                                                  obsecure: false,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return "Email is required";
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Inputs(
                                                  icon: Icon(Icons
                                                      .person_outline_outlined),
                                                  controller: address,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  hint: "Address",
                                                  obsecure: false,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return "Address is required";
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                // Inputs(
                                                //   icon: Icon(Icons
                                                //       .person_outline_outlined),
                                                //   controller: disability,
                                                //   keyboardType:
                                                //       TextInputType.text,
                                                //   hint: "Disability",
                                                //   obsecure: false,
                                                //   validator: (value) {
                                                //     if (value.isEmpty) {
                                                //       return "Disability is required";
                                                //     }
                                                //   },
                                                // ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  process == true
                                      ? Container(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: kDefault,
                                                    strokeWidth: 2.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 55)
                                      : DefaultBottom(
                                          route: () {
                                            registerUser();
                                          },
                                          title: "Save and continue",
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
