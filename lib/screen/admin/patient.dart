import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/defaultAppBar.dart';
import '../../component/subHead.dart';
import '../../constant/constant.dart';

class Patient extends StatefulWidget {
  const Patient({Key? key}) : super(key: key);

  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  var name;
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
        title: DefaultAppBar(txt: "$name"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          SizedBox(
            height: 10.0,
          ),
          SubHeader(title: "Patient Site", icon: Icons.people_alt_outlined),
          sizedBox,
        ]),
      ),
    );
  }
}
