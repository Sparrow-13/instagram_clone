import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:instagram_clone/context/cache_service.dart';
import 'package:instagram_clone/entity/user/user.dart';

import '../utils/log_utility.dart';

class UserService with ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('user');

  Future<void> addUser(User user) async {
    DocumentReference docRef = await usersCollection.add(user.toMap());
    String docId = docRef.id;
    user.id = docId;
    await docRef.update({'id': docId});
  }

  Future<void> getAllUser() {
    return usersCollection.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        LoggingService.logStatement('${doc.id} => ${doc.data()}');
      }
    }).catchError((error) {
      LoggingService.logStatement("Failed to fetch users: $error");
      return null;
    });
  }

  Future<List<User>> getUsersFromIds(List<String> userIds) async {
    List<User> users = [];
    for (String userId in userIds) {
      User? user = await getUserById(userId);
      if (user != null) {
        users.add(user);
      }
    }
    return users;
  }

// Example usage:
  Future<void> fetchAndPrintFollowers(String userId) async {
    User? user = await getUserById(userId);
    if (user != null) {
      List<User> followers = await getUsersFromIds(user.followers);
      for (User follower in followers) {
        LoggingService.logStatement('Follower: ${follower.userName}');
      }
    }
  }

// Function to fetch a user by ID (same as before)
  Future<User?> getUserById(String userId) async {
    try {
      final DocumentSnapshot snapshot = await usersCollection.doc(userId).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return User.fromMap(data);
      } else {
        return null; // User not found
      }
    } catch (e) {
      LoggingService.logStatement('Error fetching user: $e');
      return null; // Handle errors gracefully
    }
  }

  static Future<User?> fetchAndUseUser(currentUserId) async {
    if (currentUserId == null) {
      LoggingService.logStatement("userId is empty");
      return null;
    }
    UserService userService = UserService();
    User? user = await userService.getUserById(currentUserId);

    if (user != null) {
      return user;
    } else {
      LoggingService.logStatement('User not found.');
    }
    return null;
  }

  static Future<User?> fetchAndUseUserByUsername(username) async {
    if (username == null) {
      LoggingService.logStatement("username is empty");
      return null;
    }
    UserService userService = UserService();
    User? user = await userService.getUserByUsername(username);

    if (user != null) {
      return user;
    } else {
      LoggingService.logStatement('User not found.');
    }
    return null;
  }

  Future<User?> getUserByUsername(String username) async {
    try {
      final QuerySnapshot snapshot =
          await usersCollection.where('userName', isEqualTo: username).get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        return User.fromMap(data);
      } else {
        return null; // User not found
      }
    } catch (e) {
      LoggingService.logStatement('Error fetching user by username: $e');
      return null; // Handle errors gracefully
    }
  }

  Future<void> updateUserByEmail(User user) async {
    // Query for documents where 'email' matches the user's email
    QuerySnapshot querySnapshot =
        await usersCollection.where('email', isEqualTo: user.email).get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Loop through all matching documents and update them
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference
            .set(
                user.toMap(),
                SetOptions(
                    merge: true)) // Merge updated fields with existing data
            .then((value) => LoggingService.logStatement(
                "Account updated successfully for user with email ${user.email}!"))
            .catchError(
                (error) => LoggingService.logStatement("Failed to update user: $error"));
      }
    } else {
      LoggingService.logStatement("No user found with email ${user.email}.");
    }
  }

  Future<List<User>> getUsersFromUserIds(
      String userName, List<String> userIds, String boxName) async {
    List<User> users = [];

    // Open the Hive box
    var cacheBox = await Hive.openBox<List<dynamic>>(boxName);

    List<String> idsToFetchFromFirestore = [];

    // Retrieve cached data
    List<dynamic>? cachedFollowers = cacheBox.get(userName);

    if (cachedFollowers != null) {
      var cachedUserMap = {for (var user in cachedFollowers) user.id: user};

      for (var id in userIds) {
        if (cachedUserMap.containsKey(id)) {
          users.add(cachedUserMap[id]!);
        } else {
          idsToFetchFromFirestore.add(id);
        }
      }
    } else {
      idsToFetchFromFirestore.addAll(userIds);
    }

    // Fetch missing data from Firestore
    if (idsToFetchFromFirestore.isNotEmpty) {
      for (int i = 0; i < idsToFetchFromFirestore.length; i += 10) {
        var end = (i + 10 < idsToFetchFromFirestore.length)
            ? i + 10
            : idsToFetchFromFirestore.length;
        var batchIds = idsToFetchFromFirestore.sublist(i, end);

        try {
          var querySnapshot = await _fireStore
              .collection('user')
              .where(FieldPath.documentId, whereIn: batchIds)
              .get();

          var fetchedUsers = querySnapshot.docs.map((doc) {
            return User.fromFireStore(doc);
          }).toList();

          users.addAll(fetchedUsers);

          // Update cache with fetched users
          await CacheService().addAssociatedUsersToCache(userName, fetchedUsers, boxName);
        } catch (e) {
          LoggingService.logStatement("Error fetching users from Firestore: $e");
        }
      }
    }

    return users;
  }
}
