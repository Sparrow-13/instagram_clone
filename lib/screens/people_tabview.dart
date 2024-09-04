import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/followers.dart';
import 'package:instagram_clone/screens/followings.dart';

import '../entity/user.dart';

class PeopleTabView extends StatefulWidget {
  final User user;
  final int tabIndex;

  const PeopleTabView({super.key, required this.user, this.tabIndex = 0});

  @override
  State<PeopleTabView> createState() => _PeopleTabViewState();
}

class _PeopleTabViewState extends State<PeopleTabView> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      initialIndex: widget.tabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.user.userName,
            style: const TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            dividerColor: Color.fromARGB(50, 255, 255, 255),
            tabs: [
              Tab(
                text: "${widget.user.followers.length} Followers",
              ),
              Tab(
                text: "${widget.user.followers.length} Following",
              ),
              Tab(
                text: "0 Subscription",
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.black,
          width: width,
          height: height,
          child: TabBarView(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Followers(
                    user: widget.user,
                  )),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Following(
                  user: widget.user,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  color: Colors.pinkAccent,
                  height: 400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
