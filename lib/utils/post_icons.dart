// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:instagram_clone/utils/share_post_bottom_sheet.dart';
import 'dart:math' as math;

class PostIcons extends StatefulWidget {
  const PostIcons({super.key});
  @override
  State<PostIcons> createState() => PostIconsState();
}

class PostIconsState extends State<PostIcons> {
  bool liked = false;
  
  toggleLike() {
    setState(() {
      liked = !liked;
    });
  }

  bool saved = false;
  toggleSavePost() {
    setState(() {
      saved = !saved;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: (saved) ? Text("Post saved") : Text("Post unsaved"),
        duration: Duration(milliseconds: 1000),
      ));
    });
  }

  showShareBottomModal() {
    // setState(() {
    showModalBottomSheet<void>(
        // context and builder are
        // required properties in this widget
        backgroundColor: Color.fromARGB(255, 38, 38, 38),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        context: context,
        builder: (BuildContext context) {
          // we set up a container inside which
          // we create center column and display text
          // Returning SizedBox instead of a Container
          return SharePostBottomSheet();
        });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: toggleLike,
                iconSize: 28,
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_outline,
                  color: liked ? Colors.red : Colors.white,
                )),
            // SizedBox(
            //   width: 0,
            // ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: IconButton(
                  iconSize: 28,
                  onPressed: null,
                  icon: Icon(
                    FeatherIcons.messageCircle,
                    color: Colors.white,
                  )),
            ),
            IconButton(
                onPressed: showShareBottomModal,
                iconSize: 28,
                icon: Icon(
                  FeatherIcons.send,
                  color: Colors.white,
                )),
          ],
        ),
        IconButton(
          onPressed: toggleSavePost,
          iconSize: 28,
          icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border_outlined),
          color: Colors.white,
        )
      ],
    );
  }
}
