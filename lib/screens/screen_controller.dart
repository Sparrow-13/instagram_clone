// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:instagram_clone/screens/homepage.dart';
import 'package:instagram_clone/screens/prelogin/login.dart';
import 'package:instagram_clone/screens/profile_page.dart';
import 'package:instagram_clone/screens/reels_page.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:provider/provider.dart';

import '../context/global_context.dart';
import 'notification_screen.dart';

class ScreenController extends StatefulWidget {
  const ScreenController({super.key});

  @override
  State<ScreenController> createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {
  int currentIndex = 0;

  List screens = [
    HomePage(),
    SearchScreen(),
    NotificationScreen(),
    ReelsScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<GlobalContext>(context);
    final user = userProvider.user;
    if (user == null) {
      return Login();
    }
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) => setState(() {
            currentIndex = value;
          }),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Color.fromARGB(255, 194, 193, 193),
          items: [
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.house,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
              ),
              label: 'search',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.circlePlus,
              ),
              label: 'addPost',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.film,
              ),
              label: 'reels',
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(user.imageUrl),
                backgroundColor: Colors.black,
              ),
              label: 'profile',
            ),
          ],
        ),
        body: screens[currentIndex]);
  }
}
