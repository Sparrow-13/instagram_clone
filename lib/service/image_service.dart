import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/context/cache_service.dart';
import 'package:instagram_clone/service/user_service.dart';
import 'package:instagram_clone/utils/log_utility.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../context/global_context.dart';
import '../entity/user/user.dart';

class ImageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadImageToFirebase(BuildContext context, File? image, User user) async {
    if (image == null) return;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Get a reference to Firebase Storage with the specified bucket
    FirebaseStorage storage = FirebaseStorage.instanceFor();
    Reference ref = storage.ref().child('profile_images/${user.userName}/$fileName');

    try {
      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(image);

      // Show a progress indicator
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        LoggingService.logStatement('Task state: ${snapshot.state}');
        LoggingService.logStatement('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      });

      // Wait for the upload to complete
      await uploadTask.whenComplete(() => LoggingService.logStatement('File uploaded successfully'));

      // Get the download URL
      String downloadURL = await ref.getDownloadURL();
      LoggingService.logStatement('Download URL: $downloadURL');

      // Update user information with new image URL
      user.imageUrl = downloadURL;
      await UserService().updateUserByEmail(user);
      await CacheService().saveUserToCache(user);

      // Use a mounted check before using context
      if (context.mounted) {
        Provider.of<GlobalContext>(context, listen: false).setUser(user);

        // Display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully!')),
        );
      }
    } catch (e) {
      LoggingService.logStatement('Error uploading image: $e');

      // Use a mounted check before using context
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image. Please try again.')),
        );
      }
    }
  }


  Future<void> uploadFile(User firebaseUser, String filePath) async {
    try {
      File file = File(filePath);
      String fileName = path.basename(file.path); // Get the file name

      // Create a reference to the file location in Firebase Storage
      Reference storageRef = _firebaseStorage
          .ref()
          .child('uploads/${firebaseUser.email}/$fileName');

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(file);

      // Monitor the progress of the upload
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        LoggingService.logStatement('Task state: ${snapshot.state}');
        LoggingService.logStatement(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      });

      await uploadTask;
      LoggingService.logStatement('File uploaded successfully');
    } on FirebaseException catch (e) {
      if (e.code == 'unauthorized') {
        LoggingService.logStatement('User does not have permission to upload to this location.');
      } else {
        LoggingService.logStatement('Firebase Storage Error: ${e.message}');
      }
    } catch (e) {
      LoggingService.logStatement('Error uploading file: $e');
    }
  }

}
