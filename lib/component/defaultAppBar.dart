import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class DefaultAppBar extends StatelessWidget {
  final String txt;
  const DefaultAppBar({Key? key, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "M-Prescription system",
        style: TextStyle(
            fontSize: 20, color: kDefault, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        txt,
        style: TextStyle(color: kDefault, fontSize: 15),
      ),
      trailing: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("img/admin.jpg"), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(30),
          color: kWhite,
        ),
      ),
    );
  }
}
