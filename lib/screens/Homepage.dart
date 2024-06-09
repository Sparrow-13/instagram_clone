// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/components/HomepageAppBar.dart';
import 'package:instagram_clone/components/VerticalSpace.dart';
import 'package:instagram_clone/utils/StoriesWidget.dart';
import 'package:instagram_clone/utils/Feeds.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Column(
            children: [
              HomePageAppBar(),
              VerticalSpace(height: 10),
              Stories(),
              VerticalSpace(height: 10),
              Feeds()
            ],
          ),
        ),
      ),
    );
  }
}
