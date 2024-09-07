import 'package:flutter/material.dart';
import 'package:instagram_clone/context/global_context.dart';
import 'package:instagram_clone/utils/post_model.dart';
import 'package:provider/provider.dart';

import '../entity/user/user.dart';

class ViewSpecificPost extends StatefulWidget {
  final int urlIndex;
  final bool isVideoIndex;

  const ViewSpecificPost(this.urlIndex, this.isVideoIndex, {super.key});

  @override
  State<ViewSpecificPost> createState() => _ViewSpecificPostState();
}

class _ViewSpecificPostState extends State<ViewSpecificPost> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<GlobalContext>(context, listen: false).user;
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Post",
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.black),
        body: Container(
            color: Colors.black,
            child: PostModel(
              user: user!,
              urlSource: widget.urlIndex,
              isVideoUrl: widget.isVideoIndex,
            )));
  }
}
