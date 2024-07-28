// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/SplashScreen.dart';
import 'package:instagram_clone/service/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'entity/User.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // print('Firebase Initialized');
  // // await auth.FirebaseAuth.instance.setLanguageCode('en');
  // print('Locale set to \'en\'');
  // // await auth.FirebaseAuth.instance.signInAnonymously();
  // print('Signed in anonymously');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // addUser();
    return MaterialApp(home: SplashScreen());
  }

  void addUser() {
    print('Adding user');
    var user = User(
      userName: 'randomUser132',
      email: "random@email.com",
      fullName: 'Random User',
      bio: 'Some Random\nShitty Bio',
      password: 'noobmaster',
      id: '',
      followers: [],
      following: [],
      request: [],
      savedPost: [],
    );
    UserService userService = UserService();
    userService.addUser(user).then((_) {
      print('User added successfully');
    }).catchError((error) {
      print('Failed to add user: $error');
    });
  }
}
