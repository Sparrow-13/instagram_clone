import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/SpecificPost.dart';
import 'package:instagram_clone/sources/VideoSource.dart';
import 'package:instagram_clone/utils/VideoController.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

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
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Colors.white.withOpacity(0.5)),
                        suffixIcon: Icon(Icons.clear,
                            color: Colors.white.withOpacity(0.5)),
                        hintText: "search",
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
                                ViewSpecifiPost(index, isVideoIndex(index))),
                      ),
                      child: Container(
                        decoration: !isVideoIndex(index)
                            ? BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(pictures[index]),
                                    fit: BoxFit.cover))
                            : null,
                        child: isVideoIndex(index)
                            ? VideoController(videosUrl[index % 6])
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
