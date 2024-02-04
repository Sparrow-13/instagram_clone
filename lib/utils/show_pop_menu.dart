// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class PopMenu {
  showPopMenu(BuildContext context){
    return  showMenu<String>(
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
}