import 'package:flutter/material.dart';
import 'package:instagram_clone/context/global_context.dart';
import 'package:instagram_clone/sources/stories_source.dart';
import 'package:instagram_clone/utils/post_model.dart';
import 'package:provider/provider.dart';

class Feeds extends StatefulWidget {
  const Feeds({super.key});

  @override
  State<Feeds> createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<GlobalContext>(context, listen: false).user;
    return Column(
      children: List.generate(storyList.length, (index) {
        return PostModel(user: user, isVideoUrl: false, urlSource: index);
      }),
    );
  }
}
