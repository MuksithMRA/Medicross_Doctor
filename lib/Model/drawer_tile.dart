import 'package:flutter/cupertino.dart';

class DrawerTile {
  IconData icon;
  String title;
  void Function()? ontap;
  DrawerTile({
    required this.icon,
    required this.title,
    this.ontap,
  });
}
