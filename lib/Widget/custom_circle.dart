import 'package:flutter/material.dart';
import '../Constant/colors.dart';

class CustomCircle extends StatelessWidget {
  final double radius;
  final Widget? widget;
  final ImageProvider<Object>? img;
  const CustomCircle({Key? key, required this.radius, this.widget, this.img})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        backgroundImage: img,
        child: widget,
        radius: (radius / 9) * 7.5,
        backgroundColor: primaryColor,
      ),
    );
  }
}
