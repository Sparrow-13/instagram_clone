import 'package:hive/hive.dart';
import 'package:instagram_clone/entity/user/user.dart';
import 'package:instagram_clone/service/auth_service.dart';
import 'package:instagram_clone/utils/log_utility.dart';

class CacheService {
  static const String userBoxName = 'userBox';
  static const String followersBoxName = 'followersBox';
  static const String followingBoxName = 'followingBox';
  static const String requestBoxName = 'requestBox';

  Future<void> openUserBox() async {
    if (!Hive.isBoxOpen(userBoxName)) {
      try {
        await Hive.openBox<User>(userBoxName);
        logStatement("User box opened successfully.");
      } catch (e) {
        logStatement("Error opening user box: $e");
      }
    }
  }

  Future<void> openFollowersBox() async {
    if (!Hive.isBoxOpen(followersBoxName)) {
      try {
        await Hive.openBox<List<dynamic>>(
            followersBoxName); // Open as List<dynamic>
        logStatement("Followers box opened successfully.");
      } catch (e) {
        logStatement("Error opening followers box: $e");
      }
    } else {
      logStatement("Followers box is already open.");
    }
  }
  Future<void> openAssociatedUserBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<List<dynamic>>(boxName);
    }
  }

  /// Add followers to cache using `username` as the key
  Future<void> addFollowersToCache(
      String username, List<User> newFollowers) async {
        await openFollowersBox(); // Ensure the followers box is open before accessing it
        var followersBox = Hive.box<List<dynamic>>(followersBoxName); // Ensure consistent type usage

    List<User> updatedFollowers = [];

    // Retrieve the existing list of followers from the cache
    List<dynamic>? cachedFollowers = followersBox.get(username);

    if (cachedFollowers != null) {
      // Convert cached followers to a List<User>
      updatedFollowers = cachedFollowers.cast<User>();

      // Add new followers to the existing list, ensuring no duplicates
      final existingIds = updatedFollowers.map((user) => user.id).toSet();
      for (var newFollower in newFollowers) {
        if (!existingIds.contains(newFollower.id)) {
          updatedFollowers.add(newFollower);
        }
      }
    } else {
      // If no cached followers, just use the new followers list
      updatedFollowers = newFollowers;
    }

    // Save the updated list back to the cache
    await followersBox.put(username, updatedFollowers);

    logStatement("${updatedFollowers.length} Followers updated in cache for user $username: $updatedFollowers");
  }

  /// Retrieve followers from cache using `username` as the key
  Future<List<User>?> getFollowersFromCache(String username) async {
    await openFollowersBox(); // Ensure the box is open before accessing it
    var followersBox = Hive.box<List<dynamic>>(
        followersBoxName); // Ensure consistent type usage
    final dynamic followersData =
        followersBox.get(username); // Retrieve the data using username

    // Check if followersData is a List and cast it to List<User>
    if (followersData is List) {
      try {
        logStatement(
            "No of followers found in cache : ${followersData.length}");
        return followersData.cast<User>(); // Cast to List<User>
      } catch (e) {
        logStatement(
            "Error casting followers to List<User> for user $username: $e");
        return null; // Return null if casting fails
      }
    }

    return null; // Return null if followersData is not a List
  }

  /// Save a User object to the cache
  Future<void> saveUserToCache(User user) async {
    await openUserBox();
    var userBox = Hive.box<User>(userBoxName);
    await userBox.put('user', user);
    logStatement("User saved to cache: $user");
  }

  /// Retrieve a User object from the cache
  Future<User?> getUserFromCache() async {
    await openUserBox();
    var userBox = Hive.box<User>(userBoxName);

    try {
      final user = userBox.get('user');
      logStatement("User data retrieved from cache: $user");

      if (user != null) {
        AuthService().signInUser(user);
        return user;
      }
    } catch (e) {
      logStatement("Error retrieving user from cache: $e");
      await userBox.delete('user'); // Clear invalid data
    }

    return null;
  }

  /// Clear the user cache
  Future<void> emptyCache() async {
    await openUserBox();
    var userBox = Hive.box<User>(userBoxName);
    await userBox.clear();
    logStatement("Cache cleared");
  }

  /// Clear the followers cache
  Future<void> clearFollowersCache() async {
    await openFollowersBox(); // Ensure the followers box is open before accessing it
    var followersBox = Hive.box<List<User>>(followersBoxName); // Use List<User>
    await followersBox.clear();
    logStatement("Followers cache cleared");
  }
}
