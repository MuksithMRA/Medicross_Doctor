import 'package:flutter/material.dart';
import '../../Model/screen_size.dart';
import '../custom_text.dart';

class AppointmentDetailArea extends StatelessWidget {
  final String patientName;
  final String age;
  final String type;
  final String? note;
  const AppointmentDetailArea(
      {Key? key,
      required this.patientName,
      required this.age,
      required this.type,
      this.note})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: ScreenSize.height * 0.75,
        width: ScreenSize.width * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: patientName,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(
              height: ScreenSize.height * 0.01,
            ),
            CustomText(
              text: "Age : $age",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(
              height: ScreenSize.height * 0.01,
            ),
            CustomText(
              text: "Type : $type",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(
              height: ScreenSize.height * 0.07,
            ),
            const CustomText(
              text: "Note : ",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
            SizedBox(
              height: ScreenSize.height * 0.01,
            ),
            CustomText(
              text: note == "" || note == null
                  ? "No Notes from patient"
                  : note.toString(),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}