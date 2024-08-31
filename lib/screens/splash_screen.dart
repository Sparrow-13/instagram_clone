// ignore_for_file: prefer_const_constructors, file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/context/cache_service.dart';
import 'package:instagram_clone/context/global_context.dart';
import 'package:instagram_clone/entity/user.dart';
import 'package:instagram_clone/screens/screen_controller.dart';
import 'package:instagram_clone/screens/prelogin/login.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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

    // Await the result of getUserFromCache()
    var user = await CacheService().getUserFromCache(); // Await the future here

    if (user == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      }
    } else if (mounted) {
      Provider.of<GlobalContext>(context, listen: false).setUser(user);

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
