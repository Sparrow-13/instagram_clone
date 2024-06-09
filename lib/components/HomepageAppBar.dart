// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    showPopupMenu() {
      return showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(0.0, 90.0, 0.0, 0.0),
        //,    //position where you want to show the menu on screen
        items: [
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            value: 'following',
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Following',
                  style: TextStyle(),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.people_outline,
                  size: 20,
                ),
                // SizedBox(
                //   width: 10,
                // )
              ],
            ),
          ),
          PopupMenuItem<String>(
              height: 40,
              padding: EdgeInsets.zero,
              value: 'favourite',
              child: Row(children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Favourite',
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.star_border,
                  size: 20,
                ),
                // SizedBox(
                //   width: 10,
                // )
              ])),
        ],
        elevation: 1.0,
      );
    }

    return AppBar(
      title: GestureDetector(
          onTap: showPopupMenu,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text("Instagram",
                style: TextStyle(
                    fontFamily: 'insta_head',
                    fontSize: 33,
                    color: Colors.white)),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 24,
              color: Colors.white,
            )
          ])),
      // leading: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //   child: Placeholder(color: Colors.white,),
      // ),
      // leadingWidth: 400,
      backgroundColor: Colors.black,
      actions: [
        IconButton(
            tooltip: 'notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Notifications : Not Implemented Yet')));
            },
            icon: FaIcon(
              FeatherIcons.heart,
              color: Colors.white,
            )),
        IconButton(
            tooltip: 'chat',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat : Not Implemented Yet')));
            },
            icon: FaIcon(
              FeatherIcons.send,
              color: Colors.white,
            ))
      ],
    );
  }
}
