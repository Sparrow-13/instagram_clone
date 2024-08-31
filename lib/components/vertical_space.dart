import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  final double height;

  const VerticalSpace({super.key, this.height = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
