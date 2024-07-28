// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_be_immutable, file_names , use_key_in_widget_constructors

import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/SpecificPost.dart';

class ViewProfile extends StatefulWidget {
  String profileName;
  String imageurl;
  ViewProfile(this.profileName, this.imageurl);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  Faker faker = Faker();
  bool showFriendsSuggestions = true;
  int images_length = 1 + Random().nextInt(99);

  String ProfileImage_url = "https://randomuser.me/api/portraits/";
  toggleShowFriends() {
    setState(() {
      showFriendsSuggestions = !showFriendsSuggestions;
    });
  }

  String RandomProfileImage() {
    int rand = Random().nextInt(50);
    if (rand % 2 == 0) {
      return "$ProfileImage_url/women/$rand.jpg";
    }
    return "$ProfileImage_url/men/$rand.jpg";
  }

  String RandomName() {
    return "${faker.person.firstName()} ${faker.person.lastName()}";
  }

  String RandomProfileLine() {
    int rand = Random().nextInt(2);
    if (rand % 2 == 0) {
      return "New to Instagram";
    }
    return "Followed By ${faker.person.firstName()}";
  }

  var _flag = true;
  Widget Suggestion_card() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
            // color: Colors.g ,
            border: Border.all(width: 1, color: Colors.grey.shade800),
            borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.close,
                color: Colors.grey,
              ),
            ),
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(RandomProfileImage()),
            ),
            Text(
              RandomName(),
              style: GoogleFonts.roboto(
                  color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              RandomProfileLine(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 11),
            ),
            // SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => setState(() => _flag = !_flag),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _flag ? Colors.blue : Colors.grey, // This is what you need!
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  "Follow",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            titleSpacing: 0,
            title: Text(
              widget.profileName,
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ))
            ],
          ),
          body: Container(
              color: Colors.black,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    width: 90,
                                    height: 90,
                                    child: Stack(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [
                                                  // Color(0xffcc306C),
                                                  Color.fromARGB(
                                                      255, 255, 0, 225),
                                                  Color.fromARGB(
                                                      255, 255, 48, 48),
                                                  Color.fromARGB(
                                                      255, 255, 217, 67)
                                                ],
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                tileMode: TileMode.clamp,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Container(
                                                width: 90,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 4),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            widget.imageurl),
                                                        fit: BoxFit.cover)),
                                              ),
                                            )),
                                      ],
                                    )),
                                Column(
                                  children: [
                                    Text(
                                      "$images_length",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Posts",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "179K",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Followers",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "194",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Following",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.profileName,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Shitty Bio",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Nothing new here",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Go and Study hard",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.blue),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                        "Follow",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white),
                                      )),
                                    ),
                                  ),
                                )),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: toggleShowFriends,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.grey[850]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Center(
                                          child: Icon(
                                        (showFriendsSuggestions)
                                            ? Icons.person_add
                                            : Icons.person_add_outlined,
                                        color: Colors.white,
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: showFriendsSuggestions,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Discover people",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white)),
                                      InkWell(
                                        child: Text(
                                          "see more",
                                          style: GoogleFonts.roboto(
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: List.generate(
                                        10,
                                        (index) => Suggestion_card(),
                                      )))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TabBar(
                              indicatorColor: Colors.white,
                              tabs: [
                                Tab(
                                  icon: Icon(Icons.grid_on_outlined),
                                ),
                                Tab(icon: Icon(Icons.assignment_ind_outlined))
                              ],
                            ),
                            SizedBox(
                              height: (images_length ~/ 3 * 126) + 126,
                              child: TabBarView(children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: GridView.builder(
                                      primary: false,
                                      // padding: const EdgeInsets.all(20),

                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: images_length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        mainAxisExtent: 120,
                                        // childAspectRatio: 1.0
                                      ),
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return InkWell(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewSpecificPost(
                                                        index, false)),
                                          ),
                                          child: Image(
                                            image: NetworkImage(
                                                "https://picsum.photos/seed/$index/400/600"),
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: GridView.builder(
                                      primary: false,
                                      // padding: const EdgeInsets.all(20),

                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: images_length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        mainAxisExtent: 120,
                                        // childAspectRatio: 1.0
                                      ),
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return InkWell(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewSpecificPost(
                                                        index, false)),
                                          ),
                                          child: Image(
                                            image: NetworkImage(
                                                "https://picsum.photos/seed/$index/400/600"),
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }),
                                ),
                              ]),
                            ),
                          ]))))),
    );
  }
}
