// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/postModel.dart';

class ViewSpecifiPost extends StatefulWidget {
  final int urlIndex;
  final bool isVideoIndex;
  const ViewSpecifiPost(this.urlIndex, this.isVideoIndex);

  @override
  State<ViewSpecifiPost> createState() => _ViewSpecifiPostState();
}

class _ViewSpecifiPostState extends State<ViewSpecifiPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Post"), backgroundColor: Colors.black),
        body: Container(
            color: Colors.black,
            child: PostModel(
              urlsource: widget.urlIndex,
              isVideoUrl: widget.isVideoIndex,
            )));
  }
}
