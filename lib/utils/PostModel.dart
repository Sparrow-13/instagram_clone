// ignore_for_file: file_names, prefer_typing_uninitialized_variables, use_key_in_widget_constructors
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/utils/PostIcons.dart';
import 'package:instagram_clone/utils/VideoController.dart';

import '../sources/VideoSource.dart';
import 'NameSection.dart';

class PostModel extends StatefulWidget {
  final profileName;
  final bool isVideoUrl;
  final int urlSource;
  final videoUrl;

  const PostModel(
      {this.profileName,
      required this.isVideoUrl,
      required this.urlSource,
      this.videoUrl});

  @override
  State<PostModel> createState() => _PostModelState();
}

class _PostModelState extends State<PostModel> {
  final GlobalKey<PostIconsState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NameSection(),
        Stack(children: [
          InkWell(
            onDoubleTap: () => globalKey.currentState?.toggleLike(),
            child: (widget.isVideoUrl)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: VideoController(videosUrl[widget.urlSource % 6]))
                : Image(
                    image: NetworkImage(
                        "https://picsum.photos/seed/${widget.urlSource}/400/400"),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
          ),
        ]),
        PostIcons(key: globalKey),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // SizedBox(
              //   height: 5,
              // ),
              Text(
                "${Random().nextInt(10000)} likes",
                style: GoogleFonts.roboto(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              // SizedBox(
              //   height: 5,
              // ),
              Text(
                "SomeRandom_1829",
                style: GoogleFonts.roboto(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
                  Text(
                    "Some Random Caption for beautiful picture",
                    style: GoogleFonts.roboto(
                        color: Colors.grey,
                        fontSize: 14),
                  ),

              SizedBox(
                height: 5,
              ),
              Text(
                "View all 244 comments ",
                style: GoogleFonts.roboto(
                    color: Color.fromARGB(255, 186, 186, 186), fontSize: 14),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "5 hours ago",
                style: GoogleFonts.roboto(
                    color: Color.fromARGB(255, 186, 186, 186), fontSize: 12),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Color.fromARGB(255, 77, 77, 77),
                indent: 0,
                endIndent: 0,
              )
            ]))
      ],
    );
  }
}
