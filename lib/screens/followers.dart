import 'package:flutter/material.dart';
import 'package:instagram_clone/components/list_card.dart';
import 'package:instagram_clone/screens/view_profile.dart';
import 'package:instagram_clone/utils/log_utility.dart';

import '../entity/user.dart';
import '../service/user_service.dart';

class Followers extends StatefulWidget {
  final User user;

  const Followers({super.key, required this.user});

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<User> _followers = []; // All followers data
  List<User> _filteredFollowers = []; // Filtered followers data
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 0; // Page counter for pagination
  final int _pageSize = 20; // Number of items per page
  String _lastQuery = ''; // Last search query

  @override
  void initState() {
    super.initState();
    _fetchFollowers();

    // Add listener to the scroll controller to implement infinite scrolling
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          !_isLoading &&
          _hasMore) {
        logStatement("Scrolled to the bottom.");
        _fetchFollowers();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchFollowers({String query = ''}) async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var startIndex = _page * _pageSize;
      var endIndex = startIndex + _pageSize;

      if (startIndex >= widget.user.followers.length) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      var userIdsSubset = widget.user.followers.sublist(
        startIndex,
        endIndex > widget.user.followers.length
            ? widget.user.followers.length
            : endIndex,
      );

      var followers = await UserService().getUsersFromIds(userIdsSubset);

      setState(() {
        if (query.isNotEmpty) {
          // If searching, filter the results
          _followers = followers.where((user) => user.userName.toLowerCase().contains(query.toLowerCase()) || user.fullName.toLowerCase().contains(query.toLowerCase())).toList();
        } else {
          _followers.addAll(followers); // Add new batch of followers to the list
        }

        _filteredFollowers = _followers; // Update filtered followers
        _isLoading = false;
        _page++;

        if (followers.length < _pageSize) {
          _hasMore = false;
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
      logStatement("Error fetching followers: $error");
    }
  }

  void _searchFollowers(String query) {
    if (query == _lastQuery) return; // If the search query is same as last time, skip to avoid redundant call

    _lastQuery = query; // Update last query

    setState(() {
      _page = 0; // Reset page
      _followers.clear(); // Clear the previous followers list to reset it
      _filteredFollowers.clear(); // Clear filtered followers list to reset it
      _hasMore = true; // Reset loading condition
      _fetchFollowers(query: query); // Trigger search logic for the updated query
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: 40,
            width: width - 20,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: searchController,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              onChanged: (query) {
                _searchFollowers(query); // Call search logic on change
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.5)),
                  onPressed: () {
                    searchController.clear();
                    _searchFollowers(''); // Clear search results and reset list
                  },
                ),
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                labelStyle: const TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              if (index == _filteredFollowers.length && _hasMore) {
                return SizedBox(
                  height: 40,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (index >= _filteredFollowers.length) {
                return SizedBox.shrink(); // Return empty widget if beyond count
              }
              final follower = _filteredFollowers[index];
              return InkWell(
                child: ListCard(
                  imageUrl: follower.imageUrl,
                  title: follower.userName,
                  subtitle: follower.fullName,
                  onButtonPressed: () {},
                  onMenuSelected: () {},
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProfile(user: follower),
                    ),
                  );
                },
              );
            },
            childCount: _filteredFollowers.length + (_hasMore ? 1 : 0),
          ),
        ),
      ],
    );
  }
}
