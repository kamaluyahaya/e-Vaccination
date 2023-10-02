import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constant/constant.dart';
import 'myContainer.dart';

class ShowSkelaton extends StatelessWidget {
  const ShowSkelaton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Shimmer.fromColors(
          baseColor: Color(0xFFEBEBF4),
          highlightColor: Color(0xFFF4F4F4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Administrator",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "PERSONAL INFORMATION",
                      style: TextStyle(
                          color: kDefault, fontFamily: "MontSemiBold"),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  // ignore: sort_child_properties_last
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBox,
                        SizedBox(width: 10.0),
                        Container(
                          width: 70,
                          height: 100,
                          decoration: BoxDecoration(
                              color: kDefault,
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.person_outline_outlined,
                            color: kWhite,
                            size: 50,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5.0,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Email: ",
                              style: TextStyle(
                                  fontFamily: "MontSemiBold", fontSize: 14),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Gender:",
                              style: TextStyle(
                                  fontFamily: "MontSemiBold", fontSize: 14),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Phone: ",
                              style: TextStyle(
                                  fontFamily: "MontSemiBold", fontSize: 14),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Username: kamal1234",
                              style: TextStyle(
                                  fontFamily: "MontSemiBold", fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: Offset(3, 2),
                        blurRadius: 4,
                        spreadRadius: 5,
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: kWhite,
                  ),
                ),
                sizedBox,
                MyContainer(
                    head1: "Administrators",
                    head2: "Total 20",
                    color: kWhite,
                    btn_text: "View",
                    iconColor: kDefault,
                    icons: Icons.email_outlined),
                sizedBox,
                MyContainer(
                  head1: "Log out",
                  head2: "As kamal1234...",
                  color: kWhite,
                  btn_text: "Log out",
                  iconColor: Colors.orangeAccent,
                  icons: Icons.logout_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
