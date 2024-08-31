import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/entity/post.dart';

import '../utils/log_utility.dart';

class PostService with ChangeNotifier {
  Future<void> addPost(Post post) {
    CollectionReference postReference =
        FirebaseFirestore.instance.collection('post');
    return postReference
        .add(post.toMap())
        .then((value) => logStatement("Post added successfully!"))
        .catchError((error) => logStatement("Failed to add Post: $error"));
  }

  Future<void> getAllPost() {
    CollectionReference postReference =
        FirebaseFirestore.instance.collection('post');
    return postReference.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        logStatement('${doc.id} => ${doc.data()}');
      }
    }).catchError((error) {
      logStatement("Failed to fetch post: $error");
      return null;
    });
  }
}
