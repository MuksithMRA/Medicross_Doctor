import 'package:flutter/material.dart';

import '../Model/screen_size.dart';
import 'custom_button.dart';
import 'custom_text.dart';


class AlertBox extends StatelessWidget {
  final String header;
  final String message;
  const AlertBox({Key? key, required this.header, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: CustomText(text: header)),
      content: CustomText(text: message),
      actions: [
        SizedBox(
            width: ScreenSize.width,
            child: CustomButton(
              text: "Ok",
              ontap: () {
                Navigator.pop(context);
              },
            ))
      ],
    );
  }
}
