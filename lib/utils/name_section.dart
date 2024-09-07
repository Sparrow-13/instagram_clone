import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/entity/user/user.dart';
import 'package:instagram_clone/screens/view_profile.dart';
import 'package:instagram_clone/utils/bottom_modal.dart';

class NameSection extends StatefulWidget {
  @override
  State<NameSection> createState() => _NameSectionState();
  final User user;

  const NameSection({super.key, required this.user});
}

class _NameSectionState extends State<NameSection> {
  moreMenu(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                colors: const [
                                  Color(0xFFFF00E1), // Magenta
                                  Color(0xFFFF3030), // Red
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
                                        widget.user.imageUrl,
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
                              builder: (context) =>
                                  ViewProfile(user: widget.user)),
                        );
                      },
                      child: Text(widget.user.userName,
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
              onPressed: () => moreMenu(context),
              icon: Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
