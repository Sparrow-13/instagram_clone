import 'package:flutter/material.dart';

class HorizontalSpace extends StatelessWidget {
 final double width;

  const HorizontalSpace({super.key, this.width = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
