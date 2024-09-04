import 'package:flutter/material.dart';
import 'package:instagram_clone/components/list_card.dart';

import '../entity/user.dart';
import '../service/user_service.dart';

class Following extends StatefulWidget {
  final User user;

  const Following({super.key, required this.user});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  var searchController = TextEditingController();
  List<User> _allFollowings = []; // Store all followings data
  List<User> _filteredFollowings = []; // Filtered followings data
  bool _isLoading = false; // To show loading indicator during search

  @override
  void initState() {
    super.initState();
    _loadFollowings(); // Load initial followings
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFollowings() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Fetch all followings initially
    var followings = await UserService().getUsersFromIds(widget.user.following);
    setState(() {
      _allFollowings = followings; // Initialize all followings
      _filteredFollowings = followings; // Initialize filtered followings with all data
      _isLoading = false; // Hide loading indicator
    });
  }

  void _searchFollowings(String query) {
    if (query.isEmpty) {
      // If the search query is empty, display all followings
      setState(() {
        _filteredFollowings = _allFollowings;
      });
    } else {
      // Filter the followings based on the search query
      var searchResults = searchUsersByQuery(_allFollowings, query);
      setState(() {
        _filteredFollowings = searchResults;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 40,
            width: width - 20,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: searchController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              onChanged: (query) {
                _searchFollowings(query); // Call search method on change
              },
              decoration: InputDecoration(
                prefixIcon:
                Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.5)),
                  onPressed: () {
                    searchController.clear();
                    _searchFollowings(''); // Clear the search filter and reload all
                  },
                ),
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                labelStyle: const TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator() // Show loading indicator while searching
              : _filteredFollowings.isEmpty
              ? const Text(
              'No followers found') // Show message if no followers
              : Column(
            children: List.generate(
              _filteredFollowings.length,
                  (index) => ListCard(
                imageUrl: _filteredFollowings[index].imageUrl,
                title: _filteredFollowings[index].userName,
                subtitle: _filteredFollowings[index].fullName,
                onButtonPressed: () {},
                onMenuSelected: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<User> searchUsersByQuery(List<User> users, String query) {
    if (query.isEmpty) {
      return users;
    }
    final lowerQuery = query.toLowerCase();

    var filtered = users.where((user) {
      final usernameMatch = user.userName.toLowerCase().contains(lowerQuery);
      final fullNameMatch = user.fullName.toLowerCase().contains(lowerQuery);
      return usernameMatch || fullNameMatch;
    }).toList();

    return filtered;
  }
}
