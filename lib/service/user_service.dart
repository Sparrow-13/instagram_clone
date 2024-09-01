import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/entity/user.dart';

import '../utils/log_utility.dart';

class UserService with ChangeNotifier {
  Future<void> addUser(User user) {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    return users
        .add(user.toMap())
        .then((value) => logStatement("Account added successfully!"))
        .catchError((error) => logStatement("Failed to add user: $error"));
  }

  Future<void> getAllUser() {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    return users.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        logStatement('${doc.id} => ${doc.data()}');
      }
    }).catchError((error) {
      logStatement("Failed to fetch users: $error");
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
        logStatement('Follower: ${follower.userName}');
      }
    }
  }

// Function to fetch a user by ID (same as before)
  Future<User?> getUserById(String userId) async {
    try {
      final DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return User.fromMap(data);
      } else {
        return null; // User not found
      }
    } catch (e) {
      logStatement('Error fetching user: $e');
      return null; // Handle errors gracefully
    }
  }

  static Future<User?> fetchAndUseUser(currentUserId) async {
    if (currentUserId == null) {
      logStatement("userId is empty");
      return null;
    }
    UserService userService = UserService();
    User? user = await userService.getUserById(currentUserId);

    if (user != null) {
      return user;
    } else {
      logStatement('User not found.');
    }
    return null;
  }

  static Future<User?> fetchAndUseUserByUsername(username) async {
    if (username == null) {
      logStatement("username is empty");
      return null;
    }
    UserService userService = UserService();
    User? user = await userService.getUserByUsername(username);

    if (user != null) {
      return user;
    } else {
      logStatement('User not found.');
    }
    return null;
  }

  Future<User?> getUserByUsername(String username) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('userName', isEqualTo: username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        return User.fromMap(data);
      } else {
        return null; // User not found
      }
    } catch (e) {
      logStatement('Error fetching user by username: $e');
      return null; // Handle errors gracefully
    }
  }
  Future<void> updateUserByEmail(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    // Query for documents where 'email' matches the user's email
    QuerySnapshot querySnapshot = await users.where('email', isEqualTo: user.email).get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Loop through all matching documents and update them
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference
            .set(user.toMap(), SetOptions(merge: true)) // Merge updated fields with existing data
            .then((value) => logStatement("Account updated successfully for user with email ${user.email}!"))
            .catchError((error) => logStatement("Failed to update user: $error"));
      }
    } else {
      logStatement("No user found with email ${user.email}.");
    }
  }

}
