import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class SmallContainer extends StatelessWidget {
  final txt, icon, onTap, status, numbers;
  const SmallContainer(
      {Key? key, this.txt, this.icon, this.onTap, this.status, this.numbers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromARGB(255, 235, 235, 235),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              offset: Offset(3, 2),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: kDefault,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    txt,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              status == "true"
                  ? Container(
                      decoration: BoxDecoration(
                          color: kRed, borderRadius: BorderRadius.circular(50)),
                      width: 30,
                      height: 30,
                      child: Center(
                        child: Text(
                          "$numbers",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListContainer1 extends StatelessWidget {
  final title,
      dates,
      driver_name,
      onPressed,
      price,
      subtitle,
      view,
      prescribe,
      license_no,
      departure,
      destination;

  final int counter;
  const ListContainer1({
    Key? key,
    this.title,
    this.price,
    this.dates,
    this.onPressed,
    this.subtitle,
    required this.counter,
    this.license_no,
    this.departure,
    this.destination,
    this.driver_name,
    this.view,
    this.prescribe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 14.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 160,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: kWhiteSmoke),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(3, 2),
              blurRadius: 2,
              spreadRadius: 2,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Patient name:"),
                                Text("Gender:"),
                                Text("Age:"),
                                Text("Disability"),
                                Text("Address"),
                                // Text("Chasis number"),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("$title",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Bold")),
                                      // Text(" / $price")
                                    ],
                                  ),
                                  Text(
                                    "$driver_name",
                                    style: TextStyle(fontFamily: "Bold"),
                                  ),
                                  Text(
                                    "$departure",
                                    style: TextStyle(fontFamily: "Bold"),
                                  ),
                                  Text(
                                    "$license_no",
                                    style: TextStyle(fontFamily: "Bold"),
                                  ),
                                  Text(
                                    "$destination",
                                    style: TextStyle(fontFamily: "Bold"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
              ),
              sizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: prescribe,
                      child: Text("Prescribe"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: kBlue,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    height: 30,
                    child: TextButton(
                      // style: ButtonStyle(backgroundColor: kRed),
                      onPressed: view,
                      child: Text("View patient"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
