import 'package:flutter/material.dart';
import 'package:instagram_clone/components/list_card.dart';

import '../entity/user.dart';

class Followers extends StatefulWidget {
  final User user;

  const Followers({super.key, required this.user});

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  var searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: 40,
              width: width - 20,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: searchController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,
                        color: Colors.white.withOpacity(0.5)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear,
                          color: Colors.white.withOpacity(0.5)),
                      color: Colors.white.withOpacity(0.5),
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none),
              )),
          ListCard(
              imageUrl: widget.user.imageUrl,
              title: widget.user.userName,
              subtitle: widget.user.fullName,
              onButtonPressed: (){},
              onMenuSelected: (){})
        ],
      ),
    );
  }
}
