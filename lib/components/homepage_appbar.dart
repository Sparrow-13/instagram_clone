import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/context/global_context.dart';
import 'package:instagram_clone/screens/notification_screen.dart';
import 'package:provider/provider.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({super.key});

  void showPopupMenu(BuildContext context, Offset offset, Size size) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx, // X position from left
        offset.dy + size.height, // Y position just below the widget
        offset.dx + size.width, // Right boundary
        offset.dy + size.height + 1, // Bottom boundary
      ),
      color: Color.fromARGB(210, 0, 0, 0),
      items: [
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          value: 'following',
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(10), // Add padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Following',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.people_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          height: 40,
          padding: EdgeInsets.zero,
          value: 'favourite',
          child: Padding(
            padding: const EdgeInsets.all(10), // Add padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Favourite',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.star_border,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
      elevation: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<GlobalContext>(context, listen: false).user;

    final GlobalKey appBarKey = GlobalKey();

    return AppBar(
      key: appBarKey,
      title: GestureDetector(
        onTapDown: (TapDownDetails details) {
          final RenderBox renderBox =
              appBarKey.currentContext?.findRenderObject() as RenderBox;
          final Offset widgetOffset = renderBox.localToGlobal(Offset.zero);
          final Size widgetSize = renderBox.size;
          showPopupMenu(context, widgetOffset, widgetSize);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "Instagram",
              style: TextStyle(
                fontFamily: 'insta_head',
                fontSize: 33,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 24,
              color: Colors.white,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          tooltip: 'notifications',
          onPressed: () {
            Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => Request(user: user!)),
              MaterialPageRoute(
                  builder: (context) => NotificationScreen(
                        user: user!,
                      )),
            );
          },
          icon: FaIcon(
            FeatherIcons.heart,
            color: Colors.white,
          ),
        ),
        IconButton(
          tooltip: 'chat',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Chat : Not Implemented Yet')),
            );
          },
          icon: FaIcon(
            FeatherIcons.send,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
