// ignore_for_file: file_names, prefer_typing_uninitialized_variables, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/utils/postIcons.dart';
import 'package:instagram_clone/utils/video_controller.dart';

import '../sources/video_source.dart';
import 'name_section.dart';

class PostModel extends StatefulWidget {
  final profilename;
  final bool isVideoUrl;
  final int urlsource;
  final videoUrl;

  const PostModel(
      {this.profilename,
      required this.isVideoUrl,
      required this.urlsource,
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
                    child: VideoController(videosUrl[widget.urlsource % 6]))
                : Image(
                    image: NetworkImage(
                        "https://picsum.photos/seed/${widget.urlsource}/400/400"),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
          ),
        ]),
        PostIcons(key: globalKey),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 5,
              ),
              Text(
                "11,536 likes",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "akashbanerjee 👷‍♀️",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
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
