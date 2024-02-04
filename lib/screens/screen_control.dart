// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:instagram_clone/screens/homepage.dart';
import 'package:instagram_clone/screens/profile.dart';
import 'package:instagram_clone/screens/reels.dart';
import 'package:instagram_clone/screens/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FaIcon, FontAwesomeIcons;

import 'notificationscreen.dart';
// import 'package:font_awesome_flutter/name_icon_mapping.dart';

class ScreenController extends StatefulWidget {
  const ScreenController({Key? key}) : super(key: key);

  @override
  State<ScreenController> createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {
  int currentindex =0;
  
  List screens = [
    HomePage(),
    SearchScreen(),
    ReelsScreen(),
    NotificationScreen(),
    ProfileScreen('Adnan qureshi' , 'https://media-exp2.licdn.com/dms/image/C5603AQFTnjnEKc7Brg/profile-displayphoto-shrink_200_200/0/1613404214956?e=2147483647&v=beta&t=-ZO4y4Wzu-b6w7VP6ecezJfgddg5mhUr5O5dSH2eLbU')
  ]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar : BottomNavigationBar(
      currentIndex: currentindex,
      onTap: (value) => setState(() {
        currentindex = value;
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
            FontAwesomeIcons.film,
          ),
          label: 'reels',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.heart,
          ),
          label: 'notifications',
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(
                "https://media-exp2.licdn.com/dms/image/C5603AQFTnjnEKc7Brg/profile-displayphoto-shrink_200_200/0/1613404214956?e=2147483647&v=beta&t=-ZO4y4Wzu-b6w7VP6ecezJfgddg5mhUr5O5dSH2eLbU"),
            backgroundColor: Colors.black,
          ),
          label: 'profile',
        ),
      ],
    ) ,
        body: screens[currentindex] 
        );
  }
}
