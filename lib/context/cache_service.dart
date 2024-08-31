import 'package:hive/hive.dart';
import 'package:instagram_clone/utils/log_utility.dart';

import '../entity/user.dart';

class CacheService {
  Future<void> saveUserToCache(User user) async {
    var box = await Hive.openBox('userBox');
    final userData = user.toMap();
    await box.put('user', userData);
    logStatement("User saved to cache: $userData");  // Confirm data saved
  }


  Future<User?> getUserFromCache() async {
    var box = await Hive.openBox('userBox');
    final userData = box.get('user');
    logStatement("User data retrieved from cache: $userData");  // Confirm data retrieved

    if (userData is Map) {
      final Map<String, dynamic> userDataMap = Map<String, dynamic>.from(userData);
      return User.fromMap(userDataMap);
    }

    return null;
  }

}
