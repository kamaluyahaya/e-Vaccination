import 'package:flutter/material.dart';

import '../constant/constant.dart';

class AdminContainer extends StatelessWidget {
  final title, onPressed, icon, subtitle, onTap;

  final int counter;
  const AdminContainer({
    Key? key,
    this.title,
    this.onPressed,
    this.subtitle,
    required this.counter,
    this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: kWhiteSmoke),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(3, 2),
                blurRadius: 4,
                spreadRadius: 5,
              )
            ],
          ),
          child: ListTile(
            leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: kWhiteSmoke),
                ),
                child: Center(
                    child: Text(
                  '$counter',
                  style: TextStyle(color: kWhite, fontSize: 25),
                ))),
            title: Text(title, style: TextStyle(fontFamily: "RobotoBold")),
            subtitle: Text(
              '${subtitle}',
              style: TextStyle(color: kRed),
            ),
            trailing: icon,
          ),
        ),
      ),
    );
  }
}
