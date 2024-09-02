import 'dart:math';

import 'package:faker/faker.dart' as faker;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/context/global_context.dart';
import 'package:instagram_clone/screens/edit_profile.dart';
import 'package:instagram_clone/screens/people_tabview.dart';
import 'package:instagram_clone/screens/prelogin/login.dart';
import 'package:instagram_clone/screens/specific_post.dart';
import 'package:instagram_clone/service/logout_service.dart';
import 'package:instagram_clone/service/suggestion_service.dart';
import 'package:provider/provider.dart';

import '../entity/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool showFriendsSuggestions = true;
  var fakeGenerator = faker.Faker();
  int noOfImages = 1 + Random().nextInt(99);

  String profileImageUrl = "https://randomuser.me/api/portraits/";

  toggleShowFriends() {
    setState(() {
      showFriendsSuggestions = !showFriendsSuggestions;
    });
  }

  String randomProfileImage() {
    int rand = Random().nextInt(50);
    return "$profileImageUrl/${rand % 2 == 0 ? 'women' : 'men'}/$rand.jpg";
  }

  String randomName() {
    return "${fakeGenerator.person.firstName()} ${fakeGenerator.person.lastName()}";
  }

  String randomProfileLine() {
    return Random().nextInt(2) % 2 == 0
        ? "New to Instagram"
        : "Followed By ${fakeGenerator.person.firstName()}";
  }

  showAccountMenu(User user) {
    showModalBottomSheet<void>(
      backgroundColor: Color.fromARGB(255, 38, 38, 38),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 215,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 168, 168, 168),
                    borderRadius: BorderRadius.circular(15)),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user.imageUrl),
                        ),
                        SizedBox(width: 10),
                        Text(user.userName,
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    Stack(children: [
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 38, 38, 38),
                              ),
                            ),
                          )),
                    ])
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 38, 38, 38),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              )),
                          child: Icon(
                            Icons.add,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("Add Account",
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<GlobalContext>(context);
    final user = userProvider.user;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: GestureDetector(
              onTap: () => showAccountMenu(user),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                FaIcon(
                  FontAwesomeIcons.lock,
                  size: 12,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(user.userName,
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24,
                  color: Colors.grey,
                )
              ])),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Create View : Not Implemented Yet😊')));
                },
                icon: FaIcon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  navigateToLoginScreen(context);
                },
                icon: FaIcon(
                  FontAwesomeIcons.bars,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
          color: Colors.black,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: const [
                                    Color.fromARGB(255, 255, 0, 225),
                                    Color.fromARGB(255, 255, 48, 48),
                                    Color.fromARGB(255, 255, 217, 67)
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  tileMode: TileMode.clamp,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 4),
                                    image: DecorationImage(
                                      image: NetworkImage(user.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "$noOfImages",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Posts",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PeopleTabView(user: user , tabIndex: 0,),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              user.followers.length.toString(),
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Followers",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PeopleTabView(user: user , tabIndex: 1,),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              user.following.length.toString(),
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Following",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user.bio,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: navigateToEditProfile,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey[850]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Edit ",
                                  style:
                                      GoogleFonts.roboto(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey[850]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Share Profile",
                                  style:
                                      GoogleFonts.roboto(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: toggleShowFriends,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.grey[850]),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Center(
                                child: Icon(
                              showFriendsSuggestions
                                  ? Icons.person_add
                                  : Icons.person_add_outlined,
                              color: Colors.white,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: showFriendsSuggestions,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Discover people",
                                style: GoogleFonts.roboto(color: Colors.white)),
                            InkWell(
                              child: Text(
                                "see more",
                                style: GoogleFonts.roboto(
                                    color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SuggestionCardService())
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TabBar(
                    indicatorColor: Colors.white,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.grid_on_outlined, color: Colors.white),
                      ),
                      Tab(
                          icon: Icon(Icons.assignment_ind_outlined,
                              color: Colors.white))
                    ],
                  ),
                  SizedBox(
                    height: (noOfImages ~/ 3 * 126) + 126,
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: GridView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: noOfImages,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              mainAxisExtent: 120,
                            ),
                            itemBuilder: (BuildContext context, index) {
                              return InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewSpecificPost(index, false),
                                  ),
                                ),
                                child: Image(
                                  image: NetworkImage(
                                      "https://picsum.photos/seed/$index/400/600"),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: GridView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: noOfImages,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              mainAxisExtent: 120,
                            ),
                            itemBuilder: (BuildContext context, index) {
                              return InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewSpecificPost(index, false),
                                  ),
                                ),
                                child: Image(
                                  image: NetworkImage(
                                      "https://picsum.photos/seed/$index/400/600"),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getNumber(List<String> entity) {
    if (entity == null) {
      return "0";
    }
    return entity.length.toString();
  }

  navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfile()),
    );
  }

  void navigateToLoginScreen(BuildContext context) {
    LogoutService().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (Route<dynamic> route) => false,
    );
  }
}
