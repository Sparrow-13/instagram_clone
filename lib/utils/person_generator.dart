import 'dart:math';

import 'package:faker/faker.dart';

class PersonGenerator {
  String profileImageUrl = "https://randomuser.me/api/portraits/";
  late String imgURL = randomProfileImage();

  randomProfileImage() {
    int rand = Random().nextInt(50);
    if (rand % 2 == 0) {
      return "$profileImageUrl/women/$rand.jpg";
    }
    return "$profileImageUrl/men/$rand.jpg";
  }

  late String profileName = randomName();

  randomName() {
    return "${faker.person.firstName()} ${faker.person.lastName()}";
  }
}
