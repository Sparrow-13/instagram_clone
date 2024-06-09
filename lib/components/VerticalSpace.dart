import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  double height;

  VerticalSpace({super.key, this.height = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
