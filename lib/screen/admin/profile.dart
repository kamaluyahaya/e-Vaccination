import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/defaultAppBar.dart';
import '../../component/myContainer.dart';
import '../../component/skelaton.dart';
import '../../component/subHead.dart';
import '../../constant/constant.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name, email, username;
  profile() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      name = pred.getString("name");
      email = pred.getString("email");
      username = pred.getString("username");
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
                height: 5.0,
              ),
              SubHeader(
                title: "My Profile",
                icon: Icons.person_add_alt_1_outlined,
              ),
              sizedBox,
              name == null
                  ? ShowSkelaton()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "$name",
                              style: TextStyle(
                                  fontSize: 20, fontFamily: "RobotoBold"),
                            ),
                            Text(
                              "(Administrator)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15.0, fontStyle: FontStyle.italic),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "PERSONAL INFORMATION",
                                  style: TextStyle(
                                      color: kDefault,
                                      fontFamily: "MontSemiBold"),
                                )),
                            sizedBox,
                            MyContainer(
                                head1: name,
                                head2: "Administrator name",
                                color: kWhite,
                                btn_text: "",
                                iconColor: kDefault,
                                icons: Icons.email_outlined),
                            sizedBox,
                            MyContainer(
                              head1: email,
                              head2: "Email address",
                              color: kWhite,
                              btn_text: "",
                              iconColor: Colors.blue,
                              icons: Icons.email_outlined,
                            ),
                            sizedBox,
                            MyContainer(
                              head1: "Log out",
                              head2: "Login as $name",
                              color: kWhite,
                              btn_text: "",
                              iconColor: Colors.orangeAccent,
                              icons: Icons.logout_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
            ])));
  }
}
