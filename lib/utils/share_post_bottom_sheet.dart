// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/utils/person.dart';
import 'package:instagram_clone/sources/stories_source.dart';

class SharePostBottomSheet extends StatefulWidget {
  const SharePostBottomSheet({super.key});

  @override
  State<SharePostBottomSheet> createState() => _SharePostBottomSheetState();
}

class _SharePostBottomSheetState extends State<SharePostBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 430,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 168, 168, 168),
                  borderRadius: BorderRadius.circular(15)),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                  width: double.maxFinite,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 54, 54, 54),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Color.fromARGB(255, 83, 83, 83)),
                        suffixIcon: Icon(Icons.group_add,
                            color: Color.fromARGB(255, 83, 83, 83)),
                        hintText: "Search",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 100, 100, 100)),
                        border: InputBorder.none),
                  )),
            ),
            Column(
              children: List.generate(storyList.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(PersonGenerator().imgurl),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(PersonGenerator().profile_name.trim(),
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      color:
                                          Color.fromARGB(255, 202, 202, 202))),
                              Text(
                                "@${PersonGenerator().profile_name.trim()}",
                                style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 126, 126, 126)),
                              ),
                            ],
                          )
                        ],
                      ),
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            "Send",
                            style: GoogleFonts.roboto(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
