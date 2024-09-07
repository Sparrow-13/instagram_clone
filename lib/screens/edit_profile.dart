import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/components/vertical_space.dart';
import 'package:instagram_clone/context/cache_service.dart';
import 'package:instagram_clone/context/global_context.dart';
import 'package:instagram_clone/service/image_service.dart';
import 'package:instagram_clone/service/user_service.dart';
import 'package:provider/provider.dart';

import '../entity/user/user.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final bioController = TextEditingController();
  late final User user;
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<GlobalContext>(context,
        listen:
            false); // Set listen to false if you don't want rebuild on change
    user = userProvider.user!;
    userNameController.text = user.userName;
    fullNameController.text = user.fullName;
    bioController.text = user.bio;
  }

  @override
  void dispose() {
    userNameController.dispose();
    fullNameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void upsertInformation() async {
    var updatedUserName = userNameController.text;

    // Update bio and full name without async gaps
    user.bio = bioController.text;
    user.fullName = fullNameController.text;

    if (user.userName == updatedUserName) {
      // No async gaps here
      await UserService().updateUserByEmail(user);
      _updateUserAndNavigate('Profile updated successfully!');
    } else {
      // Await call introduces an async gap
      var isUserNameAvailable = (await UserService().getUserByUsername(userNameController.text) == null);

      if (isUserNameAvailable) {
        user.userName = userNameController.text;
        await UserService().updateUserByEmail(user);
        _updateUserAndNavigate('Profile updated successfully!');
      } else {
        _showSnackBar();
      }
    }
  }

  /// Helper method to update user in provider and cache and then navigate back
  void _updateUserAndNavigate(String message) {
    if (mounted) { // Check if the widget is still mounted before using context
      Provider.of<GlobalContext>(context, listen: false).setUser(user);
      CacheService().saveUserToCache(user);
      Navigator.pop(context, message);
    }
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "UserName not Available",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Edit Profile",
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.black),
        body: Container(
          color: Colors.black,
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Stack(children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: screenWidth / 8,
                      backgroundImage: (_image == null)
                          ? NetworkImage(user.imageUrl) as ImageProvider
                          : FileImage(_image!),
                    ),
                    VerticalSpace(
                      height: 10,
                    ),
                    InkWell(
                      onTap: _pickImage,
                      child: Text(
                        "Change Profile Picture",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    VerticalSpace(
                      height: 20,
                    ),
                    TextFormField(
                      controller: fullNameController,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full Name cannot be empty';
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: "Full Name",
                        label:
                            Text("Name", style: TextStyle(color: Colors.white)),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                    VerticalSpace(
                      height: 20,
                    ),
                    TextFormField(
                      controller: userNameController,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'User Name cannot be empty';
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        label: Text("User Name",
                            style: TextStyle(color: Colors.white)),
                        hintText: "User Name",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                    VerticalSpace(
                      height: 20,
                    ),
                    TextFormField(
                      controller: bioController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        label:
                            Text("Bio", style: TextStyle(color: Colors.white)),
                        hintText: "Bio",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        upsertInformation();
                        ImageService()
                            .uploadImageToFirebase(context, _image, user);
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
                          "Save",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
