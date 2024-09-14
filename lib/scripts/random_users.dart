import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';

import '../entity/user/user.dart';
import '../service/user_service.dart';
import '../utils/log_utility.dart';

void createRandomUsers(int count) async {
  UserService userService = UserService();
  final faker = Faker();
  var createdUsers = [];
  for (int i = 0; i < count; i++) {
    String randomGender =
        (i % 2 == 0) ? 'men' : 'women'; // Alternate between men and women
    String randomImageUrl =
        'https://randomuser.me/api/portraits/$randomGender/${i % 100}.jpg';

    User user = User(
      id: faker.guid.guid(),
      userName: 'user_${faker.internet.userName()}',
      email: '${faker.person.firstName().toLowerCase()}@example.com',
      fullName: faker.person.name(),
      bio: faker.lorem.sentence(),
      password: faker.internet.password(),
      imageUrl: randomImageUrl,
      followers: [],
      following: [],
      request: [],
      savedPost: [],
    );

    await userService.addUser(user);
    createdUsers.add(user);
  }
  LoggingService.logStatement(createdUsers.toString());
  LoggingService.logStatement('$count random users have been created and added to Firestore.');
}

Future<void> deleteAllRandomUsers() async {
  try {
    var usersCollection = FirebaseFirestore.instance.collection('user');
    QuerySnapshot querySnapshot = await usersCollection
        .where('userName', isGreaterThanOrEqualTo: 'user_')
        .where('userName', isLessThan: 'user_\uf8ff')
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
      LoggingService.logStatement('User ${doc.id} deleted successfully!');
    }

    LoggingService.logStatement('All random users have been deleted successfully!');
  } catch (e) {
    LoggingService.logStatement('Failed to delete random users: $e');
  }
}

Future<List<String>> fetchRandomUserIds(int limit) async {
  var usersCollection = FirebaseFirestore.instance.collection('user');
  try {
    QuerySnapshot querySnapshot = await usersCollection.limit(limit).get();
    return querySnapshot.docs.map((doc) => doc.id).toList();
  } catch (e) {
    LoggingService.logStatement('Failed to fetch random users: $e');
    return [];
  }
}

Future<void> updateUserWithRandomUsers(String userId, List<String> requestUserIds, List<String> followerUserIds, List<String> followingUserIds) async {
  var usersCollection = FirebaseFirestore.instance.collection('user');
  try {
    DocumentReference userDocRef = usersCollection.doc(userId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userDocRef);

      if (!snapshot.exists) {
        LoggingService.logStatement("User does not exist!");
        return;
      }

      List<String> followers = List<String>.from(snapshot.get('followers') ?? []);
      List<String> following = List<String>.from(snapshot.get('following') ?? []);
      List<String> requests = List<String>.from(snapshot.get('request') ?? []);

      // Adding random users to the fields
      followers.addAll(followerUserIds);
      following.addAll(followingUserIds);
      requests.addAll(requestUserIds);

      // Update the user document with new lists
      transaction.update(userDocRef, {
        'followers': followers,
        'following': following,
        'request': requests,
      });
    });

    LoggingService.logStatement('User $userId updated with random users successfully!');
  } catch (e) {
    LoggingService.logStatement('Failed to update user: $e');
  }
}

Future<void> addUsersToUserFields(String targetUserId) async {
  // Fetch exactly 25 user IDs for requests
  List<String> requestUserIds = await fetchRandomUserIds(25);

  // Fetch random number of user IDs for followers (between 50 to 80)
  int randomFollowerCount = Random().nextInt(31) + 50;  // 50 to 80
  List<String> followerUserIds = await fetchRandomUserIds(randomFollowerCount);

  // Fetch random number of user IDs for followings (between 40 to 60)
  int randomFollowingCount = Random().nextInt(21) + 40;  // 40 to 60
  List<String> followingUserIds = await fetchRandomUserIds(randomFollowingCount);

  // Remove the targetUserId from any of the lists to avoid self-reference
  requestUserIds.removeWhere((id) => id == targetUserId);
  followerUserIds.removeWhere((id) => id == targetUserId);
  followingUserIds.removeWhere((id) => id == targetUserId);

  // Update the target user's fields with the fetched users
  await updateUserWithRandomUsers(targetUserId, requestUserIds, followerUserIds, followingUserIds);
}
