import 'package:flutter/material.dart';
import 'package:instagram_clone/components/list_card.dart';
import 'package:instagram_clone/context/cache_service.dart';
import 'package:instagram_clone/screens/profile/view_profile.dart';
import 'package:instagram_clone/utils/log_utility.dart';

import '../../entity/user/user.dart';
import '../../service/user_service.dart';

class Followers extends StatefulWidget {
  final User user;

  const Followers({super.key, required this.user});

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<User> _followers = [];
  List<User> _filteredFollowers = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 0;
  final int _pageSize = 20;
  final _cacheService = CacheService();
  bool _isCacheExhausted = false;

  @override
  void initState() {
    super.initState();
    _initialize();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50 &&
          !_isLoading &&
          _hasMore) {
        _fetchMoreFollowers();
      }
    });

    searchController.addListener(() {
      _searchFollowers(searchController.text);
    });
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _cacheService.openAssociatedUserBox(CacheService.followersBoxName);
      await _fetchInitialFollowers(); // Fetch after box is opened
    } catch (e) {
      LoggingService.logStatement(
          "_FollowersState - _initialize: Error initializing followers: $e");
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _fetchInitialFollowers() async {
    setState(() {
      _isLoading = true;
      _page = 0; // Reset page when fetching initial data
    });

    try {
      await _cacheService.openAssociatedUserBox(CacheService.followersBoxName);

      // Fetch from cache first
      List<User>? cachedFollowers = await _cacheService
          .getAssociatedUsersFromCache(widget.user.userName, CacheService.followersBoxName);

      if (cachedFollowers != null && cachedFollowers.isNotEmpty) {
        setState(() {
          _followers.addAll(cachedFollowers);
          _filteredFollowers = List.from(_followers);
          _isLoading = false;
          _hasMore = cachedFollowers.length >= _pageSize;
          _isCacheExhausted = cachedFollowers.length <
              widget.user.followers.length; // Check if cache covers all data
        });
        LoggingService.logStatement(
            "_FollowersState - _fetchInitialFollowers: Fetched followers from cache.");
        return; // Return if followers found in cache
      }

      // Fetch initial followers from Firestore if not found in cache
      await _fetchFollowersFromDatabase(0); // Fetch first page
    } catch (error) {
      LoggingService.logStatement(
          "_FollowersState - _fetchInitialFollowers: Error fetching initial followers: $error");
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _fetchMoreFollowers() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (!_isCacheExhausted) {
        int startIndex = (_page + 1) * _pageSize;
        if (startIndex < _followers.length) {
          setState(() {
            _filteredFollowers = _followers.sublist(0, startIndex + _pageSize);
            _isLoading = false;
            _page++;
            _hasMore = _filteredFollowers.length < widget.user.followers.length;
          });
          return;
        } else {
          _isCacheExhausted = true;
        }
      }

      await _fetchFollowersFromDatabase(_page + 1);
    } catch (error) {
      LoggingService.logStatement(
          "_FollowersState - _fetchMoreFollowers: Error fetching more followers: $error");
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _fetchFollowersFromDatabase(int page) async {
    int startIndex = page * _pageSize;
    int endIndex = startIndex + _pageSize;

    if (startIndex >= widget.user.followers.length) {
      setState(() {
        _hasMore = false;
        _isLoading = false;
      });
      return;
    }

    List<String> userIdsSubset = widget.user.followers.sublist(
      startIndex,
      endIndex > widget.user.followers.length
          ? widget.user.followers.length
          : endIndex,
    );

    LoggingService.logStatement(
        "_FollowersState - _fetchFollowersFromDatabase: Fetching followers from index $startIndex to $endIndex.");

    List<User> moreFollowers = await UserService()
        .getUsersFromUserIds(widget.user.userName, userIdsSubset, CacheService.followersBoxName);

    // Handle duplicates in the fetched data
    for (var newFollower in moreFollowers) {
      if (!_followers.any((user) => user.userName == newFollower.userName)) {
        _followers.add(newFollower);
      } else {
        LoggingService.logStatement(
            "_FollowersState - _fetchFollowersFromDatabase: Duplicate detected for user ${newFollower.userName}.");
      }
    }

    setState(() {
      _filteredFollowers = List.from(_followers);
      _isLoading = false;
      _page++;

      if (moreFollowers.length < _pageSize) {
        _hasMore = false;
      }
    });
  }

  void _searchFollowers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFollowers = _followers;
      });
    } else {
      setState(() {
        _filteredFollowers = _followers
            .where((user) =>
        user.userName.toLowerCase().contains(query.toLowerCase()) ||
            user.fullName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
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
              decoration: InputDecoration(
                prefixIcon:
                Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.5)),
                  onPressed: () {
                    searchController.clear();
                    _searchFollowers('');
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

