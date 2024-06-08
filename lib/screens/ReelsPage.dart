import 'package:flutter/material.dart';
import 'package:instagram_clone/sources/VideoSource.dart';
import 'package:instagram_clone/utils/VideoController.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  State<ReelsScreen> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsScreen> {

   List<Widget> videos = List<Widget>.generate(videosUrl.length, (index) => VideoController(videosUrl[index]),);
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);
    return Scaffold(
      // body: ListView.builder(
      //     itemCount: videosUrl.length,
      //     itemBuilder: (BuildContext context, index) => Container(
      //         height: MediaQuery.of(context).size.height,
      //         width: MediaQuery.of(context).size.width,
      //         color: Colors.grey,
      //         child: PageView(
      //             controller: pageController,
      //             children: [VideoController(videosUrl[index])]))),
      body: PageView(
        controller: pageController,
        scrollDirection: Axis.vertical,
        children: videos,
      ),
    );
  }
}