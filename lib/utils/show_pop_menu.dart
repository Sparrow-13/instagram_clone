import 'package:flutter/material.dart';

class PopMenu {
  showPopMenu(BuildContext context) {
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
            children: const [
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
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.star_border,
                size: 20,
              )
            ])),
      ],
      elevation: 1.0,
    );
  }
}
