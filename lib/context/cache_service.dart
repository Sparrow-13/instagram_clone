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
        LoggingService.logStatement("User box opened successfully.");
      } catch (e) {
        LoggingService.logStatement("Error opening user box: $e");
      }
    }
  }

  Future<void> openAssociatedUserBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      try {
        await Hive.openBox<List<dynamic>>(boxName);
        LoggingService.logStatement("$boxName  opened successfully.");
      } catch (e) {
        LoggingService.logStatement("Exception while opening $boxName");
      }
    } else {
      LoggingService.logStatement("$boxName  is already open.");
    }
  }

  /// Add followers to cache using `username` as the key
  Future<void> addAssociatedUsersToCache<T>(
      String username, List<T> newData, String boxName) async {
    await openAssociatedUserBox(boxName); // Ensure the box is open
    var box = Hive.box<List<dynamic>>(boxName);

    // Retrieve the existing list from the cache
    List<T> updatedData = [];

    // Use a Set for uniqueness check based on user ID
    final existingIds = <dynamic>{};
    List<dynamic>? cachedData = box.get(username);

    if (cachedData != null) {
      updatedData = cachedData.cast<T>();
      // Assuming T is a User type with an 'id' field
      existingIds.addAll(updatedData.map((item) => (item as dynamic).id));
      LoggingService.logStatement("Initial cached data for user $username: ${updatedData.length} items.");
    } else {
      LoggingService.logStatement("No initial cache found for user $username.");
    }

    // Loop through the new data and check for duplicates using user ID
    for (var newItem in newData) {
      // Assuming 'newItem' has an 'id' field
      final newItemId = (newItem as dynamic).id;
      if (!existingIds.contains(newItemId)) {
        updatedData.add(newItem);
        existingIds.add(newItemId);
      } else {
        LoggingService.logStatement("Duplicate detected for user $username: ${newItem.id}");
      }
    }

    // Save the updated list back to the cache
    await box.put(username, updatedData);

    LoggingService.logStatement(
        "Updated cache for user $username with ${newData.length} new items. Total cache size: ${updatedData.length}.");
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
        LoggingService.logStatement("No of items found in cache: ${data.length}");
        return data.cast<T>(); // Cast to List<T>
      } catch (e) {
        LoggingService.logStatement("Error casting data to List<T> for user $username: $e");
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
    LoggingService.logStatement("User saved to cache: $user");
  }

  /// Retrieve a User object from the cache
  Future<User?> getUserFromCache() async {
    await openUserBox();
    var userBox = Hive.box<User>(userBoxName);

    try {
      final user = userBox.get('user');
      LoggingService.logStatement("User data retrieved from cache: $user");

      if (user != null) {
        AuthService().signInUser(user);
        return user;
      }
    } catch (e) {
      LoggingService.logStatement("Error retrieving user from cache: $e");
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
    LoggingService.logStatement("User cache cleared");

    // Open and clear the followers box
    await openAssociatedUserBox(followersBoxName);
    var followersBox = Hive.box<List<dynamic>>(followersBoxName);
    await followersBox.clear();
    LoggingService.logStatement("Followers cache cleared");

    // Add any other boxes that need to be cleared
    await openAssociatedUserBox(followingBoxName);
    var followingBox = Hive.box<List<dynamic>>(CacheService.followingBoxName);
    await followingBox.clear();
    LoggingService.logStatement("Following cache cleared");

    await openAssociatedUserBox(requestBoxName);
    var requestsBox = Hive.box<List<dynamic>>(CacheService.requestBoxName);
    await requestsBox.clear();
    LoggingService.logStatement("Requests cache cleared");

    LoggingService.logStatement("All caches cleared on logout.");
  }
}
