import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:evaccinations/screen/admin/dashboard.dart';
import 'package:evaccinations/screen/admin/patient.dart';
import 'package:evaccinations/screen/admin/payment-record.dart';
import 'package:evaccinations/screen/admin/payment.dart';
import 'package:evaccinations/screen/admin/profile.dart';
import '../../component/double_click_close.dart';
import '../../constant/constant.dart';
import 'add_patient.dart';
import 'prescription-record.dart';
import 'records.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  List<Widget> _option = [
    Dashboard(),
    AddPatient(),
    Payment(),
    PaymentRecord(),
    Profile(),
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: _option[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        color: Color.fromARGB(77, 141, 132, 132),
        backgroundColor: kWhite,
        items: [
          Icon(
            Icons.home_outlined,
            color: kBlack,
          ),
          Icon(
            Icons.person_add_alt_1_outlined,
            color: kBlack,
          ),
          Icon(
            Icons.payment_outlined,
            color: kBlack,
          ),
          Icon(
            Icons.people_outline_outlined,
            color: kBlack,
          ),
          Icon(
            Icons.person_pin_outlined,
            color: kBlack,
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class AdminNav extends StatefulWidget {
  const AdminNav({Key? key}) : super(key: key);

  @override
  State<AdminNav> createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {
  List<Widget> _option = [
    DoubleClick(child: PrescriberDash()),
    DoubleClick(child: PrescriptionRec(true)),
    DoubleClick(child: Record(true)),
    DoubleClick(child: Profile()),
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: _option[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        color: Color.fromARGB(77, 141, 132, 132),
        backgroundColor: kWhite,
        items: [
          Icon(
            Icons.home_outlined,
            color: kBlack,
          ),
          Icon(
            Icons.file_copy_outlined,
            color: kBlack,
          ),
          Icon(
            Icons.reviews_outlined,
            color: kBlack,
          ),
          Icon(
            Icons.person_pin,
            color: kBlack,
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
