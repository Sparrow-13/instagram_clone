import 'package:firebase_auth/firebase_auth.dart';

import '../entity/user.dart'
    as user; // Adjusted import to avoid naming conflict

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInUser(user.User user) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      if (userCredential.user != null) {
        print('User signed in successfully: ${userCredential.user?.email}');
      } else {
        print('Sign-in failed. User credential is null.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        print('Invalid email format.');
      } else {
        print('Firebase Auth Error: ${e.message}');
      }
    } catch (e) {
      print('General Error signing in user: $e');
    }
  }

  Future<void> logoutUser() async {
    try {
      await _firebaseAuth.signOut();
      print('User logged out successfully.');
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}