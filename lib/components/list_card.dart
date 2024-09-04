import 'package:flutter/material.dart';
import 'package:instagram_clone/components/horizontal_space.dart';

class ListCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback onButtonPressed;
  final VoidCallback onMenuSelected;

  const ListCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onButtonPressed,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.black,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(imageUrl),
            ),
            HorizontalSpace(
              width: 15,
            ),
            // Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Button Section
            TextButton(
              onPressed: onButtonPressed,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.grey.shade700; // Darker grey when pressed
                    }
                    return Colors.grey.shade800; // Default grey color
                  },
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Message'),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMenuSelected,
            ),
          ],
        ),
      ),
    );
  }
}
