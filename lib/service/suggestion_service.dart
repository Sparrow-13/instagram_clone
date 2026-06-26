import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import '../components/person_suggestion_card.dart';

class SuggestionCardService extends StatefulWidget {
  const SuggestionCardService({super.key});

  @override
  State<SuggestionCardService> createState() => _SuggestionCardServiceState();
}

class _SuggestionCardServiceState extends State<SuggestionCardService> {
  String baseProfileURL = "https://randomuser.me/api/portraits/";
  Faker faker = Faker();
  List<Map<String, String>> cards = [];

  @override
  void initState() {
    super.initState();
    cards = generateList(); // Initialize cards in initState
  }

  List<Map<String, String>> generateList() {
    return List.generate(
        10,
        (index) => {
              'username': randomName(),
              'imageUrl': randomProfileImage(),
              'status': randomProfileLine(),
            });
  }

  void removeCard(int index) {
    setState(() {
      cards.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        cards.length,
        (index) => SuggestionPersonCard(
          username: cards[index]['username']!,
          imageUrl: cards[index]['imageUrl']!,
          status: cards[index]['status']!,
          onRemove: () => removeCard(index), // Pass callback to card
        ),
      ),
    );
  }

  String randomProfileImage() {
    int rand = Random().nextInt(50);
    if (rand % 2 == 0) {
      return "$baseProfileURL/women/$rand.jpg";
    }
    return "$baseProfileURL/men/$rand.jpg";
  }

  String randomName() {
    return "${faker.person.firstName()} ${faker.person.lastName()}";
  }

  String randomProfileLine() {
    int rand = Random().nextInt(2);
    if (rand % 2 == 0) {
      return "New to Instagram";
    }
    return "Followed By ${faker.person.firstName()}";
  }
}
