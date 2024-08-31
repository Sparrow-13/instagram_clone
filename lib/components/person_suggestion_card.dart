import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuggestionPersonCard extends StatefulWidget {
  final String username;
  final String imageUrl;
  final String status;
  final VoidCallback onRemove;

  const SuggestionPersonCard(
      {super.key,
      required this.username,
      required this.imageUrl,
      required this.status,
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
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: 150,
        height: 210,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.shade800),
            borderRadius: BorderRadius.circular(5.0)),
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
            Text(
              widget.username,
              style: GoogleFonts.roboto(
                  color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.status,
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
                  _flag ? "Follow" : "requested",
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
