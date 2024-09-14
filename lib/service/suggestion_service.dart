import 'package:flutter/material.dart';
import 'package:instagram_clone/service/user_service.dart';

import '../components/person_suggestion_card.dart';
import '../entity/user/user.dart';
import '../screens/profile/view_profile.dart';

class SuggestionCardService extends StatefulWidget {
  const SuggestionCardService({super.key, required this.user});

  final User user;

  @override
  State<SuggestionCardService> createState() => _SuggestionCardServiceState();
}

class _SuggestionCardServiceState extends State<SuggestionCardService> {
  List<User> unfollowedList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUnfollowedUsers();
  }

  Future<void> _loadUnfollowedUsers() async {
    List<User> fetchedUnfollowedUsers = await fetchUnfollowedUsers(widget.user);

    // Limit to 10 users only
    setState(() {
      unfollowedList = fetchedUnfollowedUsers.take(10).toList();
      isLoading = false;
    });
  }

  void removeCard(int index) {
    setState(() {
      unfollowedList.removeAt(index);
    });
  }

  void selectProfile(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewProfile(user: unfollowedList[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return unfollowedList.isEmpty
        ? const Text("No suggestions available",
            style: TextStyle(color: Colors.white))
        : Row(
            children: List.generate(
              unfollowedList.length,
              (index) => SuggestionPersonCard(
                username: unfollowedList[index].userName,
                imageUrl: unfollowedList[index].imageUrl,
                status: 'Suggested',
                onSelect: () => selectProfile(index),
                onRemove: () => removeCard(index),
              ),
            ),
          );
  }

  Future<List<User>> fetchUnfollowedUsers(User user) async {
    // Step 1: Fetch all users
    List<User> allUsers = await UserService().getAllUsers();

    // Step 2: Filter out users the logged-in user already follows
    List<String> loggedInUserFollowing = user.following;
    List<User> unfollowedUsers =
        getUnfollowedUsers(allUsers, loggedInUserFollowing);

    return unfollowedUsers;
  }

  List<User> getUnfollowedUsers(
      List<User> allUsers, List<String> loggedInUserFollowing) {
    return allUsers
        .where((user) => !loggedInUserFollowing.contains(user.id))
        .toList();
  }
}
