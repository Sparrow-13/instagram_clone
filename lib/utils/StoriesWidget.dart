// ignore_for_file: prefer_const_constructors , file_names
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/sources/StoriesSource.dart';

class Stories extends StatelessWidget {
  const Stories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(children: [
                  SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    // Color(0xffcc306C),
                                    Color.fromARGB(255, 255, 0, 225),
                                    Color.fromARGB(255, 255, 48, 48),
                                    Color.fromARGB(255, 255, 217, 67)
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  tileMode: TileMode.clamp,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.black, width: 4),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://media-exp2.licdn.com/dms/image/C5603AQFTnjnEKc7Brg/profile-displayphoto-shrink_200_200/0/1613404214956?e=2147483647&v=beta&t=-ZO4y4Wzu-b6w7VP6ecezJfgddg5mhUr5O5dSH2eLbU"),
                                          fit: BoxFit.cover)),
                                ),
                              )),
                        ],
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                      width: 75,
                      child: Align(
                          child: Text("Your story",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600))))
                ])),
            Row(
              children: List.generate(storyList.length, (index) {
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        SizedBox(
                            width: 80,
                            height: 80,
                            child: Stack(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          // Color(0xffcc306C),
                                          Color.fromARGB(255, 255, 0, 225),
                                          Color.fromARGB(255, 255, 48, 48),
                                          Color.fromARGB(255, 255, 217, 67)
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        tileMode: TileMode.clamp,
                                      ),
                                      // border: Border.all(
                                      //     // color: Color(0xffcc306C),
                                      //     width: 5)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 4),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  storyList[index]['imageUrl'],
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                    )),
                              ],
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                            width: 75,
                            child: Align(
                                child: Text(storyList[index]['name'],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600))))
                      ],
                    ));
              }),
            )
          ],
        ));
  }
}
