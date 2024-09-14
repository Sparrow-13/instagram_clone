import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/components/vertical_space.dart';

class SuggestionPersonCard extends StatefulWidget {
  final String username;
  final String imageUrl;
  final String status;
  final VoidCallback onSelect;
  final VoidCallback onRemove;

  const SuggestionPersonCard(
      {super.key,
      required this.username,
      required this.imageUrl,
      required this.status,
      required this.onSelect,
      required this.onRemove});

  @override
  State<SuggestionPersonCard> createState() => _SuggestionPersonCardState();
}

class _SuggestionPersonCardState extends State<SuggestionPersonCard> {
  var _flag = true;

  @override
  Widget build(BuildContext context) {
    return suggestionCard();
  }

  Widget suggestionCard() {
    return InkWell(
      onTap: widget.onSelect,
      child: Container(
        width: 170,
        // height: 210,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: Colors.white12, // Move the color inside BoxDecoration
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: widget.onRemove,
                child: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              ),
            ),
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(widget.imageUrl),
            ),
            VerticalSpace(
              height: 5,
            ),
            Text(
              widget.username,
              style: GoogleFonts.roboto(
                  color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            VerticalSpace(
              height: 5,
            ),
            Text(
              widget.status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 11),
            ),
            VerticalSpace(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () => setState(() => _flag = !_flag),
              style: ElevatedButton.styleFrom(
                backgroundColor: _flag ? Colors.blue : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Small corner radius
                ),
              ),
              child: SizedBox(
                width: 100,
                child: Text(
                  _flag ? "Follow" : "Requested",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
