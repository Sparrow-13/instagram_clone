import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../entity/user/user.dart' as user;
import '../utils/log_utility.dart';

class UpdateUser {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('user');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> updateAllUsersWithDocId() async {
    try {
      QuerySnapshot querySnapshot = await usersCollection.get();

      // Iterate over each document
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Get the document ID
        String docId = doc.id;

        // Update the document with the document ID
        await doc.reference.update({'id': docId});

        LoggingService.logStatement('Updated user with ID: $docId');
      }

      LoggingService.logStatement('All users updated with document IDs.');
    } catch (e) {
      LoggingService.logStatement('Error updating users with document IDs: $e');
    }
  }

  Future<void> upsertAllUsersToAuth() async {
    try {
      // Fetch all users from Firestore
      QuerySnapshot userSnapshots = await usersCollection.get();
      List<QueryDocumentSnapshot> userDocs = userSnapshots.docs;

      for (var doc in userDocs) {
        user.User myuser = user.User.fromFireStore(doc);
        try {
          // Check if the user already exists in Firebase Auth
          List<String> signInMethods =
              await _firebaseAuth.fetchSignInMethodsForEmail(myuser.email);

          if (signInMethods.isEmpty) {
            // If the user does not exist in Firebase Auth, create them
            UserCredential userCredential =
                await _firebaseAuth.createUserWithEmailAndPassword(
              email: myuser.email,
              password:
                  myuser.password, // You might need to handle password securely
            );

            User? firebaseUser = userCredential.user;
            if (firebaseUser != null) {
              LoggingService.logStatement(
                  "User created in Auth:${myuser.email} - ${firebaseUser.uid}");
            }
          } else {
            LoggingService.logStatement(
                "User already exists in Auth: ${myuser.email}");
          }
        } catch (e) {
          LoggingService.logStatement(
              "Error processing user ${myuser.email}: $e");
        }
      }
    } catch (e) {
      LoggingService.logStatement("Error fetching users from Firestore: $e");
    }
  }
  List<String> removeCommonFollowers(List<String> followers, List<String> requests) {
    Set<String> requestsSet = requests.toSet();
    return followers.where((follower) => !requestsSet.contains(follower)).toList();
  }
}
