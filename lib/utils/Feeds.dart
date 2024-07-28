// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/PostModel.dart';
import 'package:instagram_clone/sources/StoriesSource.dart';


class Feeds extends StatefulWidget {
  @override
  State<Feeds> createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(storyList.length, (index) {
        return PostModel(isVideoUrl: false, urlSource: index );
      }),
    );
  }
}
