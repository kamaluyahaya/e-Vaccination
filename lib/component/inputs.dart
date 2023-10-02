import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class Inputs extends StatelessWidget {
  final hint, obsecure;
  final controller, keyboardType, text, color, validator;
  final Icon icon;
  const Inputs(
      {Key? key,
      this.hint,
      required this.icon,
      this.controller,
      this.keyboardType,
      this.text,
      this.color,
      this.validator,
      this.obsecure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: TextFormField(
                keyboardType: keyboardType,
                controller: controller,
                validator: validator,
                obscureText: obsecure,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: hint,
                  border: OutlineInputBorder(),
                  prefixIcon: icon,
                )),
          )
        ],
      ),
    );
  }
}
