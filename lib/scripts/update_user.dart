import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/log_utility.dart';

class UpdateUser {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('user');

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
}
