import 'package:flutter/material.dart';
import 'package:instagram_clone/components/list_card.dart';
import 'package:instagram_clone/screens/profile/view_profile.dart';

import '../../context/cache_service.dart';
import '../../entity/user/user.dart';
import '../../service/user_service.dart';
import '../../utils/log_utility.dart';

class Following extends StatefulWidget {
  final User user;

  const Following({super.key, required this.user});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<User> _following = [];
  List<User> _filteredFollowing = [];
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
        _fetchMoreFollowing();
      }
    });

    searchController.addListener(() {
      _searchFollowing(searchController.text);
    });
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _cacheService.openAssociatedUserBox(CacheService.followingBoxName);
      await _fetchInitialFollowing(); // Fetch after box is opened
    } catch (e) {
      LoggingService.logStatement("Error initializing following: $e");
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _fetchInitialFollowing() async {
    setState(() {
      _isLoading = true;
      _page = 0; // Reset page when fetching initial data
    });

    try {
      // Ensure the Hive box is opened before accessing it
      await _cacheService.openAssociatedUserBox(
          CacheService.followingBoxName); // Ensure the Hive box is opened

      // Fetch from cache first
      List<User>? cachedFollowing =
      await _cacheService.getAssociatedUsersFromCache(widget.user.userName,
          CacheService.followingBoxName); // Await the result
      if (cachedFollowing != null && cachedFollowing.isNotEmpty) {
        setState(() {
          _following.addAll(cachedFollowing);
          _filteredFollowing = List.from(_following);
          _isLoading = false;
          _hasMore = cachedFollowing.length >= _pageSize;
          _isCacheExhausted = cachedFollowing.length <
              widget.user.following.length; // Check if cache covers all data
        });
        return;
      }


      await _fetchFollowingFromDatabase(0); // Fetch first page
    } catch (error) {
      LoggingService.logStatement("Error fetching initial following: $error");
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _fetchMoreFollowing() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (!_isCacheExhausted) {
        int startIndex = (_page + 1) * _pageSize;
        if (startIndex < _following.length) {
          setState(() {
            _filteredFollowing = _following.sublist(0, startIndex + _pageSize);
            _isLoading = false;
            _page++;
            _hasMore = _filteredFollowing.length < widget.user.following.length;
          });
          return;
        } else {
          _isCacheExhausted = true;
        }
      }

      await _fetchFollowingFromDatabase(_page + 1);
    } catch (error) {
      LoggingService.logStatement("Error fetching more following: $error");
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _fetchFollowingFromDatabase(int page) async {
    int startIndex = page * _pageSize;
    int endIndex = startIndex + _pageSize;

    if (startIndex >= widget.user.following.length) {
      setState(() {
        _hasMore = false;
        _isLoading = false;
      });
      return;
    }

    List<String> userIdsSubset = widget.user.following.sublist(
      startIndex,
      endIndex > widget.user.following.length
          ? widget.user.following.length
          : endIndex,
    );

    List<User> moreFollowing = await UserService()
        .getUsersFromUserIds(widget.user.userName, userIdsSubset , CacheService.followingBoxName);

    setState(() {
      _following.addAll(moreFollowing);
      _filteredFollowing = List.from(_following);
      _isLoading = false;
      _page++;

      if (moreFollowing.length < _pageSize) {
        _hasMore = false;
      }
    });
  }

  void _searchFollowing(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFollowing = _following;
      });
    } else {
      setState(() {
        _filteredFollowing = _following
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
                    _searchFollowing('');
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
              if (index == _filteredFollowing.length && _hasMore) {
                return SizedBox(
                  height: 40,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final following = _filteredFollowing[index];
              return InkWell(
                child: ListCard(
                  imageUrl: following.imageUrl,
                  title: following.userName,
                  subtitle: following.fullName,
                  onButtonPressed: () {},
                  onMenuSelected: () {},
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProfile(user: following),
                    ),
                  );
                },
              );
            },
            childCount: _filteredFollowing.length + (_hasMore ? 1 : 0),
          ),
        ),
      ],
    );
  }}
