import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/utils/log_utility.dart';

import '../entity/user/user.dart' as user;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInUser(user.User user) async {
    try {
      logStatement('Attempting to sign in as ${user.email}');
      UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      if (userCredential.user != null) {
        logStatement('User signed in successfully: ${userCredential.user?.email}');
      } else {
        logStatement('Sign-in failed. User credential is null.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logStatement('No user found for email ${user.email}.');
      } else if (e.code == 'wrong-password') {
        logStatement('Wrong password provided for user ${user.email}.');
      } else if (e.code == 'invalid-email') {
        logStatement('Invalid email format for ${user.email}.');
      } else {
        logStatement('Firebase Auth Error: ${e.message}');
      }
    } catch (e) {
      logStatement('General Error signing in user: $e');
    }
  }


  Future<void> logoutUser() async {
    try {
      await _firebaseAuth.signOut();
      logStatement('User logged out successfully.');
    } catch (e) {
      logStatement('Error logging out: $e');
    }
  }
}
