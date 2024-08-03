import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/entity/Post.dart';

class PostService with ChangeNotifier {
  Future<void> addPost(Post post) {
    CollectionReference postReference = FirebaseFirestore.instance.collection('post');
    return postReference
        .add(post.toMap())
        .then((value) => print("Post added successfully!"))
        .catchError((error) => print("Failed to add Post: $error"));
  }

  Future<void> getAllPost() {
    CollectionReference postReference = FirebaseFirestore.instance.collection('post');
    return postReference.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print('${doc.id} => ${doc.data()}');
      });
    }).catchError((error) => print("Failed to fetch post: $error"));
  }
}
