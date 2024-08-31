// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/post_model.dart';

class ViewSpecificPost extends StatefulWidget {
  final int urlIndex;
  final bool isVideoIndex;

  const ViewSpecificPost(this.urlIndex, this.isVideoIndex);

  @override
  State<ViewSpecificPost> createState() => _ViewSpecificPostState();
}

class _ViewSpecificPostState extends State<ViewSpecificPost> {
  @override
  Widget build(BuildContext context) {
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
              urlSource: widget.urlIndex,
              isVideoUrl: widget.isVideoIndex,
            )));
  }
}
