import 'package:flutter/material.dart';
import 'package:instagram_clone/sources/video_source.dart';
import 'package:instagram_clone/utils/video_controller.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsScreen> {
  List<Widget> videos = List<Widget>.generate(
    videosUrl.length,
    (index) => VideoController(videosUrl[index]),
  );

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);
    return Scaffold(
      body: PageView(
        controller: pageController,
        scrollDirection: Axis.vertical,
        children: videos,
      ),
    );
  }
}
