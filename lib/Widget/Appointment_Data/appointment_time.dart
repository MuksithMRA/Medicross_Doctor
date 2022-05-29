import 'package:flutter/material.dart';

import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../custom_text.dart';

class AppointmentTime extends StatelessWidget {
  final String date;
  final String time;
  const AppointmentTime({
    Key? key,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(ScreenSize.width * 0.3)),
        child: SizedBox(
          height: ScreenSize.height * 0.38,
          width: ScreenSize.width,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: date,
                color: kwhite,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
              CustomText(
                text: time,
                color: kwhite,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ],
          )),
        ),
      ),
    );
  }
}