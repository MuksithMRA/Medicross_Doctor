import 'package:flutter/material.dart';
import 'package:medicross_doctor/Model/appointment.dart';
import 'package:medicross_doctor/Provider/database_service.dart';
import 'package:provider/provider.dart';
import '../../Model/screen_size.dart';
import '../custom_button.dart';

class ButtonSet extends StatelessWidget {
  final Appointment appointment;
  const ButtonSet({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseService>(
      builder: (context, db, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                elevation: 0,
                text: "Accept",
                width: ScreenSize.width * 0.4,
                ontap: () {
                  db.acceptAppointment(appointment, context);
                },
              ),
              CustomButton(
                elevation: 0,
                backgroundColor: Colors.black.withOpacity(0.1),
                fontColor: Colors.black,
                text: "Reject",
                width: ScreenSize.width * 0.4,
                ontap: () {
                  db.rejectAppointment(appointment, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
