// ignore_for_file: prefer_const_constructors, file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/context/GlobalContext.dart';
import 'package:instagram_clone/screens/ScreenController.dart';
import 'package:instagram_clone/service/UserService.dart';
import 'package:provider/provider.dart';

import '../entity/User.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    // Wait for 2 seconds
    await Future.delayed(Duration(seconds: 2));

    // Fetch user data
    final user = await UserService.fetchAndUseUser();

    // Update the user in the provider
    if (mounted) {
      Provider.of<GlobalContext>(context, listen: false).setUser(user!);

      // Navigate to ScreenController after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenController(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: Image.asset(
              "assets/instagram_logo.png",
              width: 100,
              height: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              children: [
                Text(
                  'from',
                  style: GoogleFonts.roboto(color: Colors.grey),
                ),
                Image.asset(
                  "assets/Instagram_meta.png",
                  width: 110,
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
