import 'package:flutter/material.dart';
import 'package:medicross_doctor/Widget/appointment_card.dart';
import '../Constant/colors.dart';
import '../Model/appointment.dart';
import '../Model/screen_size.dart';
import '../Widget/Appointment_Data/appointment_detail_area.dart';
import '../Widget/Appointment_Data/appointment_time.dart';
import '../Widget/Appointment_Data/avatar_area.dart';
import '../Widget/Appointment_Data/button_set.dart';
import '../Widget/custom_text.dart';

class AppointmentData extends StatelessWidget {
  final Appointment appointment;
  const AppointmentData({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: const CustomText(text: "Appointment Request"),
        ),
        body: Stack(
          children: [
            SizedBox(
              height: ScreenSize.height,
              width: ScreenSize.width,
              child: AppointmentTime(
                date: appointment.date,
                time: appointment.time,
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.46,
              width: ScreenSize.width * 0.85,
              child: AvatarArea(
                appointment: appointment,
              ),
            ),
            AppointmentDetailArea(
              age: appointment.patientAge.toString(),
              patientName: appointment.patientName,
              type: appointment.appointmentType,
              note: appointment.note,
            ),
            appointment.status == "Pending"
                ? ButtonSet(
                    appointment: appointment,
                  )
                : appointment.status == "Accepted"
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: IfAccepted(appointment: appointment))
                    : const Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          title: CustomText(
                            text: "Rejected",
                            color: Colors.red,
                          ),
                        ),
                      )
          ],
        ));
  }
}
