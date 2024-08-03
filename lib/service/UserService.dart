import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/entity/User.dart';

class UserService with ChangeNotifier {
  Future<void> addUser(User user) {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    return users
        .add(user.toMap())
        .then((value) => print("Account added successfully!"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> getAllUser() {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    return users.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print('${doc.id} => ${doc.data()}');
      });
    }).catchError((error) => print("Failed to fetch users: $error"));
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
        print('Follower: ${follower.userName}');
      }
    }
  }

// Function to fetch a user by ID (same as before)
  Future<User?> getUserById(String userId) async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('user') // Replace 'users' with your collection name
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return User.fromMap(data);
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null; // Handle errors gracefully
    }
  }
  static Future<User?> fetchAndUseUser() async {
    UserService userService = UserService();
    var currentUserId = "yr7mdwpTQvsVYHI6lMof"; // Mark the function as 'async'
    User? user = await userService.getUserById(currentUserId);

    if (user != null) {
      return user;
    } else {
      print('User not found.');
    }
    return null;
  }
}
