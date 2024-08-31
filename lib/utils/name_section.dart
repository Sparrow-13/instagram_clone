// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, must_be_immutable
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:math';

import 'package:faker/faker.dart' as faker;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/view_profile.dart';
import 'package:instagram_clone/utils/bottom_modal.dart';

class NameSection extends StatefulWidget {
  @override
  State<NameSection> createState() => _NameSectionState();
  NameSection();

  String ProfileImage_url = "https://randomuser.me/api/portraits/";
  late String imageURL = RandomProfileImage();
  RandomProfileImage() {

    int rand = Random().nextInt(50);
    if (rand % 2 == 0) {
      return "$ProfileImage_url/women/$rand.jpg";
    }
    return "$ProfileImage_url/men/$rand.jpg";
  }

  late String profile_name = RandomName();
  RandomName() {
    return "${faker.Faker().person.firstName()} ${faker.Faker().person.lastName()}";
  }
}

class _NameSectionState extends State<NameSection> {
  more_menu() {
    setState(() {
      showModalBottomSheet<void>(
          backgroundColor: Color.fromARGB(255, 38, 38, 38),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          context: context,
          builder: (BuildContext context) {

            return BottomModalMenu();
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical:5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 35,
                  height: 35,
                  child: Stack(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFF00E1),  // Magenta
                                  Color(0xFFFF3030),  // Red
                                  Color(0xFFFFD943)
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                tileMode: TileMode.clamp,
                              )),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        widget.imageURL,
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                          )),
                    ],
                  )),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Row(children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewProfile(
                                  widget.profile_name, widget.imageURL)),
                        );
                      },
                      child: Text(widget.profile_name,
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 5),
                    FaIcon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 16,
                    )
                  ])
                ],
              )
            ],
          ),
          IconButton(
              onPressed: more_menu,
              icon: Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
