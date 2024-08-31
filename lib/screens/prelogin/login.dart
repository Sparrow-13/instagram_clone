import 'package:flutter/material.dart';
import 'package:instagram_clone/components/horizontal_space.dart';
import 'package:instagram_clone/context/cache_service.dart';
import 'package:instagram_clone/screens/prelogin/sign_up.dart';
import 'package:instagram_clone/screens/screen_controller.dart';
import 'package:instagram_clone/service/login_service.dart';
import 'package:provider/provider.dart';

import '../../components/vertical_space.dart';
import '../../context/global_context.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  late bool passwordVisibility = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "To be implemented",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  void checkLogin() async {
    // Await the result from checkLogin()
    var user = await LoginService().checkLogin(
      userNameController.text,
      passwordController.text,
    );

    if (user != null) {
      await CacheService().saveUserToCache(user);
      updateContext(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenController(),
        ),
      );
    } else {
      // Handle login failure (e.g., show a snack bar or error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please check your credentials.')),
      );
    }
  }

  updateContext(user) {
    Provider.of<GlobalContext>(context, listen: false).setUser(user);
  }

  navigateToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignUp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey, // Form key to identify the form
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Instagram",
                      style: TextStyle(
                        fontFamily: 'insta_head',
                        fontSize: screenWidth * 0.10,
                        color: Colors.white,
                      ),
                    ),
                    TextFormField(
                      controller: userNameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      cursorColor: Colors.white,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username cannot be empty';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    VerticalSpace(height: 10),
                    TextFormField(
                      controller: passwordController,
                      style: TextStyle(color: Colors.white),
                      obscureText: !passwordVisibility,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisibility
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisibility = !passwordVisibility;
                            });
                          },
                        ),
                      ),
                      cursorColor: Colors.white,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    VerticalSpace(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: _showSnackBar,
                        child: Text(
                          "Forget password?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    VerticalSpace(height: 30),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          checkLogin(); // Only shows snackbar if form is valid
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        width: screenWidth,
                        height: 40,
                        child: Center(
                          child: Text(
                            "Log In",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  HorizontalSpace(width: 5),
                  InkWell(
                    onTap: navigateToSignUp,
                    child: Text(
                      "Sign Up.",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
