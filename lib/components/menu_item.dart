import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onClick;

  MenuItem({required this.title, required this.icon, required this.onClick});
}
