

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    showPopupMenu() {
      return showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(0.0, 90.0, 0.0, 0.0),
        color: Color.fromARGB(210, 0, 0, 0),
        //,    //position where you want to show the menu on screen
        items: [
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            value: 'following',
            height: 40,
            child: Row(
              children: const [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Following',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.people_outline,
                  color: Colors.white,
                  size: 20,
                )
              ],
            ),
          ),
          PopupMenuItem<String>(
              height: 40,
              padding: EdgeInsets.zero,
              value: 'favourite',
              child: Row(children: const [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Favourite',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.star_border,
                  color: Colors.white,
                  size: 20,
                )
              ])),
        ],
        elevation: 1.0,
      );
    }

    return AppBar(
      title: GestureDetector(
          onTap: showPopupMenu,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
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
