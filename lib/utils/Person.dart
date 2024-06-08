// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:math';

import 'package:faker/faker.dart';

class PersonGenerator {
  String ProfileImage_url = "https://randomuser.me/api/portraits/";
  late String imgurl = RandomProfileImage();
  RandomProfileImage() {
    int rand = Random().nextInt(50);
    if (rand % 2 == 0) {
      return "$ProfileImage_url/women/$rand.jpg";
    }
    return "$ProfileImage_url/men/$rand.jpg";
  }

  late String profile_name = RandomName();
  RandomName() {
    return "${faker.person.firstName()} ${faker.person.lastName()}";
  }
}
