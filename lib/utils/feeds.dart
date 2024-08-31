
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/post_model.dart';
import 'package:instagram_clone/sources/stories_source.dart';


class Feeds extends StatefulWidget {
  const Feeds({super.key});

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
