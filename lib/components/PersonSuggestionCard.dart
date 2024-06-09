import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuggestionPersonCard extends StatefulWidget {
  const SuggestionPersonCard({super.key});

  @override
  State<SuggestionPersonCard> createState() => _SuggestionPersonCardState();
}

class _SuggestionPersonCardState extends State<SuggestionPersonCard> {
  bool showFriendsSuggestions = true;
  Faker faker = Faker();
  int imagesLength = 1 + Random().nextInt(99);
  String baseProfileURL = "https://randomuser.me/api/portraits/";

  @override
  Widget build(BuildContext context) {
    return suggestionCard();
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

  var _flag = true;

  Widget suggestionCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
            // color: Colors.g ,
            border: Border.all(width: 1, color: Colors.grey.shade800),
            borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.close,
                color: Colors.grey,
              ),
            ),
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(randomProfileImage()),
            ),
            Text(
              randomName(),
              style: GoogleFonts.roboto(
                  color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              randomProfileLine(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 11),
            ),
            // SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => setState(() => _flag = !_flag),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _flag ? Colors.blue : Colors.grey, // This is what you need!
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  "Follow",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
