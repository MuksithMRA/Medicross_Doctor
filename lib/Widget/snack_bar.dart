import 'package:flutter/material.dart';
import '../Constant/colors.dart';
import '../Model/screen_size.dart';
import 'custom_text.dart';

SnackBar customSnackBar(String message, IconData icon, Color bgColor) {
  return SnackBar(
    action: SnackBarAction(
        label: "Close",
        textColor: kwhite,
        onPressed: () {
          SnackBarClosedReason.hide;
        }),
    content: Row(
      children: [
        Icon(
          icon,
          color: kwhite,
        ),
        SizedBox(
          width: ScreenSize.width * 0.02,
        ),
        CustomText(
          text: message,
          color: kwhite,
        ),
      ],
    ),
    backgroundColor: bgColor,
  );
}
