import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';

class DoubleClick extends StatelessWidget {
  final child;
  const DoubleClick({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBack(
        message: "Press the back button again to exit",
        child: child,
      ),
    );
  }
}
