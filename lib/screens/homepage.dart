import 'package:flutter/material.dart';
import 'package:instagram_clone/components/homepage_appbar.dart';
import 'package:instagram_clone/components/vertical_space.dart';
import 'package:instagram_clone/utils/feeds.dart';
import 'package:instagram_clone/utils/stories_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
            children: const [
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
