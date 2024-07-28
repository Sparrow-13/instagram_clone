import 'package:cloud_firestore/cloud_firestore.dart';
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
}
