import 'package:flutter/material.dart';

import '../constant/constant.dart';

class DefaultButton extends StatelessWidget {
  final color, title, onPress, icon;
  DefaultButton({super.key, this.color, this.title, this.onPress, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        child: OutlinedButton(
            onPressed: onPress,
            style: OutlinedButton.styleFrom(side: BorderSide.none),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: kWhite,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "$title",
                  style: TextStyle(color: kWhite, fontSize: 15),
                ),
              ],
            )));
  }
}
