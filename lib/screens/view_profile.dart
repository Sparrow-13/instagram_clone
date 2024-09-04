import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/people_tabview.dart';
import 'package:instagram_clone/screens/specific_post.dart';
import 'package:instagram_clone/service/suggestion_service.dart';

import '../entity/user.dart';

class ViewProfile extends StatefulWidget {
  final User user;

  const ViewProfile({super.key, required this.user});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  bool showFriendsSuggestions = true;
  int imagesLength = 1 + Random().nextInt(99);

  toggleShowFriends() {
    setState(() {
      showFriendsSuggestions = !showFriendsSuggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            titleSpacing: 0,
            title: Text(
              widget.user.userName,
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.black,
            actions: const [
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
                                                colors: const [
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
                                                            widget
                                                                .user.imageUrl),
                                                        fit: BoxFit.cover)),
                                              ),
                                            )),
                                      ],
                                    )),
                                Column(
                                  children: [
                                    Text(
                                      "$imagesLength",
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
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PeopleTabView(
                                          user: widget.user,
                                          tabIndex: 0,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.user.followers.length.toString(),
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
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PeopleTabView(
                                          user: widget.user,
                                          tabIndex: 1,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.user.following.length.toString(),
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
                                  widget.user.fullName,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  widget.user.bio,
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
                                      child: SuggestionCardService())
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TabBar(
                              indicatorColor: Colors.white,
                              dividerColor: Colors.white24,
                              labelColor: Colors.white,
                              tabs: const [
                                Tab(
                                  icon: Icon(Icons.grid_on_outlined),
                                ),
                                Tab(icon: Icon(Icons.assignment_ind_outlined))
                              ],
                            ),
                            SizedBox(
                              height: (imagesLength ~/ 3 * 126) + 126,
                              child: TabBarView(children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: GridView.builder(
                                      primary: false,
                                      // padding: const EdgeInsets.all(20),

                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: imagesLength,
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
                                      itemCount: imagesLength,
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
