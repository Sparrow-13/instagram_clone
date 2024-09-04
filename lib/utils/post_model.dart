// ignore_for_file: file_names, prefer_typing_uninitialized_variables, use_key_in_widget_constructors
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/components/vertical_space.dart';
import 'package:instagram_clone/utils/post_icons.dart';
import 'package:instagram_clone/utils/video_controller.dart';

import '../sources/video_source.dart';
import 'name_section.dart';

class PostModel extends StatefulWidget {
  final user;
  final bool isVideoUrl;
  final int urlSource;
  final videoUrl;

  const PostModel(
      {required this.user,
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
        NameSection(
          user: widget.user,
        ),
        Stack(children: [
          InkWell(
            onDoubleTap: () => globalKey.currentState?.toggleLike(),
            child: (widget.isVideoUrl)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: VideoController(
                        videosUrl[widget.urlSource % videosUrl.length]),
                  )
                : Image(
                    image: NetworkImage(
                        "https://picsum.photos/seed/${widget.urlSource}/400/400"),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                  ),
          )
        ]),
        PostIcons(key: globalKey),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "${Random().nextInt(10000)} likes",
                style: GoogleFonts.roboto(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "SomeRandom_1829",
                style: GoogleFonts.roboto(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Some Random Caption for beautiful picture",
                style: GoogleFonts.roboto(color: Colors.grey, fontSize: 14),
              ),
              VerticalSpace(
                height: 5,
              ),
              Text(
                "View all 244 comments ",
                style: GoogleFonts.roboto(color: Colors.grey, fontSize: 14),
              ),
              VerticalSpace(
                height: 5,
              ),
              Text(
                "5 hours ago",
                style: GoogleFonts.roboto(color: Colors.grey, fontSize: 12),
              ),
              VerticalSpace(
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
