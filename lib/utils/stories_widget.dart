import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/components/vertical_space.dart';
import 'package:instagram_clone/context/global_context.dart';
import 'package:instagram_clone/service/user_service.dart';
import 'package:provider/provider.dart';

import '../entity/user/user.dart';

class Stories extends StatelessWidget {
  const Stories({super.key});

  Future<List<User>> getFollowers(User user, int startIndex, int endIndex) async {
    var userIdsSubset = user.followers.sublist(
      startIndex,
      endIndex > user.followers.length ? user.followers.length : endIndex,
    );
    var followers = await UserService().getUsersFromIds(userIdsSubset);
    return followers;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<GlobalContext>(context, listen: false).user;

    if (user == null) {
      return Center(child: Text('No user found.'));
    }

    return FutureBuilder<List<User>>(
      future: getFollowers(user, 0, 20),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No followers found.'));
        } else {
          var followers = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: const [
                                    Color.fromARGB(255, 255, 0, 225),
                                    Color.fromARGB(255, 255, 48, 48),
                                    Color.fromARGB(255, 255, 217, 67),
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  tileMode: TileMode.clamp,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black, width: 4),
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
                      VerticalSpace(height: 5),
                      SizedBox(
                        width: 75,
                        child: Align(
                          child: Text(
                            "Your story",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(followers.length, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: const [
                                        Color.fromARGB(255, 255, 0, 225),
                                        Color.fromARGB(255, 255, 48, 48),
                                        Color.fromARGB(255, 255, 217, 67),
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      tileMode: TileMode.clamp,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: 4),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(followers[index].imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 75,
                            child: Align(
                              child: Text(
                                followers[index].userName,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
