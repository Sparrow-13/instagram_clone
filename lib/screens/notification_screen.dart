import 'package:flutter/material.dart';
import 'package:instagram_clone/entity/user/user.dart';
import 'package:instagram_clone/screens/request.dart';
import 'package:instagram_clone/service/user_service.dart';

import '../components/vertical_space.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.user});

  final User user;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<List<User>?>? _requestedUsersFuture;

  @override
  void initState() {
    super.initState();
    _requestedUsersFuture = getRequestUsers();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => Request(user: user!)),
                  MaterialPageRoute(
                      builder: (context) => Request(
                            user: widget.user!,
                          )),
                )
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<User>?>(
                  future: _requestedUsersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    } else if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      var requestedUsers = snapshot.data!;
                      return Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              for (int i = 0; i < requestedUsers.length; i++)
                                Align(
                                  widthFactor: .3,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                    ),
                                    margin: EdgeInsets.only(
                                        left: i.toDouble() * 10),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        requestedUsers[i]
                                            .imageUrl, // Adjust this based on your User model
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Follow Request",
                                style: TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Approve or Ignore request",
                                style: TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      // Don't show anything if there are no requests
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
            VerticalSpace(
              height: 10,
            ),
            // Divider Line
            const Divider(color: Colors.white24, thickness: 0.5),

            // Notifications Section
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual notification count
                itemBuilder: (context, index) {
                  return ListTile();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<User>?> getRequestUsers() async {
    var request =
        widget.user.request; // Assuming 'request' is a list of user IDs
    if (request.isEmpty) {
      return null;
    }
    var requestIds = (request.length == 1)
        ? request
        : request.sublist(0, 2); // Adjust this as needed
    var requestUsers = await UserService().getUsersFromIds(requestIds);
    return requestUsers;
  }
}
