import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/specific_post.dart';
import 'package:instagram_clone/sources/video_source.dart';
import 'package:instagram_clone/utils/video_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int counter = 0;
  String imgUrl = "https://random.imagecdn.app/";

  bool isVideoIndex(int index) {
    List indices = [2, 11, 18, 27, 34, 43, 50, 59, 66];
    return indices.contains(index);
  }

  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> pictures = List.generate(
        150, ((index) => "https://picsum.photos/seed/$index/400/600"));
    // for (String s in pictures) {
    //   print(s);
    // }
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    controller: textController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Colors.white.withOpacity(0.5)),
                        suffixIcon: Icon(Icons.clear,
                            color: Colors.white.withOpacity(0.5)),
                        hintText: "search",
                        alignLabelWithHint: true,
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: InputBorder.none),
                  )),
            ),
            Expanded(
              child: GridView.custom(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 3,
                      pattern: const [
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(2, 1),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                      ],
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      repeatPattern: QuiltedGridRepeatPattern.inverted),
                  childrenDelegate:
                      SliverChildBuilderDelegate((context, index) {
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewSpecificPost(index, isVideoIndex(index))),
                      ),
                      child: Container(
                        decoration: !isVideoIndex(index)
                            ? BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(pictures[index]),
                                    fit: BoxFit.cover))
                            : null,
                        child: isVideoIndex(index)
                            ? VideoController(
                                videosUrl[index % videosUrl.length])
                            : null,
                      ),
                    );
                  })),
            ),
          ],
        ),
      )),
    );
  }
}
