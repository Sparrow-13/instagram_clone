import 'package:flutter/material.dart';

import '../context/cache_service.dart';
import '../entity/user/user.dart';
import '../service/user_service.dart';
import '../utils/log_utility.dart';

class Request extends StatefulWidget {
  final User loggedInUser;

  const Request({super.key, required this.loggedInUser});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  final ScrollController _scrollController = ScrollController();
  final List<User> _request = [];
  List<User> _filteredRequest = [];
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
        _fetchMoreRequest();
      }
    });
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _cacheService.openAssociatedUserBox(CacheService.requestBoxName);
      await _fetchInitialRequest(); // Fetch after box is opened
    } catch (e) {
      LoggingService.logStatement(
          "_RequestState - _initialize: Error initializing request: $e");
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _fetchInitialRequest() async {
    setState(() {
      _isLoading = true;
      _page = 0; // Reset page when fetching initial data
    });

    try {
      await _cacheService.openAssociatedUserBox(CacheService.requestBoxName);

      // Fetch from cache first
      List<User>? cachedRequest =
          await _cacheService.getAssociatedUsersFromCache(
              widget.loggedInUser.userName, CacheService.requestBoxName);

      if (cachedRequest != null && cachedRequest.isNotEmpty) {
        setState(() {
          _request.addAll(cachedRequest);
          _filteredRequest = List.from(_request);
          _isLoading = false;
          _hasMore = cachedRequest.length >= _pageSize;
          _isCacheExhausted = cachedRequest.length <
              widget.loggedInUser.request
                  .length; // Check if cache covers all data
        });
        LoggingService.logStatement(
            "_RequestState - _fetchInitialRequest: Fetched request from cache.");
        return; // Return if request found in cache
      }

      // Fetch initial request from Firestore if not found in cache
      await _fetchRequestFromDatabase(0); // Fetch first page
    } catch (error) {
      LoggingService.logStatement(
          "_RequestState - _fetchInitialRequest: Error fetching initial request: $error");
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _fetchMoreRequest() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (!_isCacheExhausted) {
        int startIndex = (_page + 1) * _pageSize;
        if (startIndex < _request.length) {
          setState(() {
            _filteredRequest = _request.sublist(0, startIndex + _pageSize);
            _isLoading = false;
            _page++;
            _hasMore =
                _filteredRequest.length < widget.loggedInUser.request.length;
          });
          return;
        } else {
          _isCacheExhausted = true;
        }
      }

      await _fetchRequestFromDatabase(_page + 1);
    } catch (error) {
      LoggingService.logStatement(
          "_RequestState - _fetchMoreRequest: Error fetching more request: $error");
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  Future<void> _fetchRequestFromDatabase(int page) async {
    int startIndex = page * _pageSize;
    int endIndex = startIndex + _pageSize;

    if (startIndex >= widget.loggedInUser.request.length) {
      setState(() {
        _hasMore = false;
        _isLoading = false;
      });
      return;
    }

    List<String> userIdsSubset = widget.loggedInUser.request.sublist(
      startIndex,
      endIndex > widget.loggedInUser.request.length
          ? widget.loggedInUser.request.length
          : endIndex,
    );

    LoggingService.logStatement(
        "_RequestState - _fetchRequestFromDatabase: Fetching request from index $startIndex to $endIndex.");

    List<User> moreRequest = await UserService().getUsersFromUserIds(
        widget.loggedInUser.userName,
        userIdsSubset,
        CacheService.requestBoxName);

    // Handle duplicates in the fetched data
    for (var newRequest in moreRequest) {
      if (!_request.any((user) => user.userName == newRequest.userName)) {
        _request.add(newRequest);
      } else {
        LoggingService.logStatement(
            "_RequestState - _fetchRequestFromDatabase: Duplicate detected for user ${newRequest.userName}.");
      }
    }

    setState(() {
      _filteredRequest = List.from(_request);
      _isLoading = false;
      _page++;

      if (moreRequest.length < _pageSize) {
        _hasMore = false;
      }
    });
  }

  void removeUserFromList(User user) {
    setState(() {
      _filteredRequest.remove(user);
    });
  }

  void _handleConfirm(User user) async {
    try {
      widget.loggedInUser.followers.add(user.id);
      await UserService().updateUserByEmail(widget.loggedInUser);

      if (!mounted) return; // Check if the widget is still mounted

      removeUserFromList(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Confirmed ${user.userName}\'s request')),
      );

      LoggingService.logStatement(
          "_RequestState - _handleConfirm: Confirmed request for ${user.userName}");
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      LoggingService.logStatement(
          "_RequestState - _handleConfirm: Failed to confirm request for ${user.userName} - $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to confirm request for ${user.userName}')),
      );
    }
  }

  void _handleReject(User user) async {
    try {
      widget.loggedInUser.request.remove(user.id);
      await UserService().updateUserByEmail(widget.loggedInUser);

      if (!mounted) return; // Check if the widget is still mounted

      removeUserFromList(user);
      _cacheService.saveUserToCache(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted ${user.userName}\'s request')),
      );

      LoggingService.logStatement(
          "_RequestState - _handleReject: Rejected request for ${user.userName}");
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      LoggingService.logStatement(
          "_RequestState - _handleReject: Failed to reject request for ${user.userName} - $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to reject request for ${user.userName}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Follow Request",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _filteredRequest.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _filteredRequest.length) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final request = _filteredRequest[index];

            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(request.imageUrl),
                radius: 30,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    request.userName,
                    style: const TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    request.fullName,
                    style: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => _handleConfirm(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _handleReject(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
