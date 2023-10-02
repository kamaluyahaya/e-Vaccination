import 'package:flutter/material.dart';

import '../constant/constant.dart';

class DefaultBottom extends StatelessWidget {
  final route, title, color, icon;
  const DefaultBottom({this.route, this.title, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(50)),
        width: MediaQuery.of(context).size.width,
        child: OutlinedButton(
            onPressed: route,
            style: OutlinedButton.styleFrom(side: BorderSide.none),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: kWhite,
                  size: 16,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "$title",
                  style: TextStyle(
                      color: kWhite, fontSize: 16, fontFamily: "Medium"),
                ),
              ],
            )));
  }
}
