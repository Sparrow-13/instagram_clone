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

  Future<void> openAssociatedUserBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      try {
        await Hive.openBox<List<dynamic>>(boxName);
        logStatement("$boxName  opened successfully.");
      } catch (e) {
        logStatement("Exception while opening $boxName");
      }
    } else {
      logStatement("$boxName  is already open.");
    }
  }

  /// Add followers to cache using `username` as the key
  Future<void> addAssociatedUsersToCache<T>(
      String username, List<T> newData, String boxName) async {
    await openAssociatedUserBox(boxName); // Ensure the box is open
    var box = Hive.box<List<dynamic>>(boxName);

    List<T> updatedData = [];

    // Retrieve the existing list from the cache
    List<dynamic>? cachedData = box.get(username);

    if (cachedData != null) {
      // Convert cached data to a List<T>
      updatedData = cachedData.cast<T>();

      // Add new data to the existing list, ensuring no duplicates
      final existingIds = updatedData.map((item) => item.toString()).toSet();
      for (var newItem in newData) {
        if (!existingIds.contains(newItem.toString())) {
          updatedData.add(newItem);
        }
      }
    } else {
      // If no cached data, just use the new data list
      updatedData = newData;
    }

    // Save the updated list back to the cache
    await box.put(username, updatedData);

    logStatement(
        "${box.length} items updated in cache for user $username: $updatedData");
  }

  /// Retrieve followers from cache using `username` as the key
  Future<List<T>?> getAssociatedUsersFromCache<T>(
      String username, String boxName) async {
    await openAssociatedUserBox(boxName); // Ensure the box is open
    var box = Hive.box<List<dynamic>>(boxName);
    final dynamic data = box.get(username); // Retrieve the data using username

    // Check if data is a List and cast it to List<T>
    if (data is List) {
      try {
        logStatement("No of items found in cache: ${data.length}");
        return data.cast<T>(); // Cast to List<T>
      } catch (e) {
        logStatement("Error casting data to List<T> for user $username: $e");
        return null; // Return null if casting fails
      }
    }

    return null; // Return null if data is not a List
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
  Future<void> clearAllCache() async {
    // Open and clear the user box
    await openUserBox();
    var userBox = Hive.box<User>(userBoxName);
    await userBox.clear();
    logStatement("User cache cleared");

    // Open and clear the followers box
    await openAssociatedUserBox(followersBoxName);
    var followersBox = Hive.box<List<dynamic>>(followersBoxName);
    await followersBox.clear();
    logStatement("Followers cache cleared");

    // Add any other boxes that need to be cleared
    await openAssociatedUserBox(followingBoxName);
    var followingBox = Hive.box<List<dynamic>>(CacheService.followingBoxName);
    await followingBox.clear();
    logStatement("Following cache cleared");

    await openAssociatedUserBox(requestBoxName);
    var requestsBox = Hive.box<List<dynamic>>(CacheService.requestBoxName);
    await requestsBox.clear();
    logStatement("Requests cache cleared");

    logStatement("All caches cleared on logout.");
  }
}
