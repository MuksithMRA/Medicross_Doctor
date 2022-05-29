import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../Animation/page_transition_slide.dart';
import '../Model/appointment.dart';
import '../Provider/database_service.dart';
import '../Provider/register_controller.dart';
import '../Screen/appointment_data.dart';
import 'custom_button.dart';
import 'custom_text.dart';
import 'snack_bar.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const AppointmentCard({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
      builder: (context, regCtrl, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.width * 0.05,
              vertical: ScreenSize.height * 0.02),
          child: SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height * 0.36,
            child: Material(
              elevation: 5,
              color: kwhite,
              borderRadius: BorderRadius.circular(25),
              child: Column(
                children: [
                  SizedBox(
                    height: ScreenSize.height * 0.11,
                    width: ScreenSize.width,
                    child: Material(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Appointment Request",
                              fontSize: 17,
                              color: kwhite.withOpacity(0.7),
                            ),
                            SizedBox(
                              height: ScreenSize.height * 0.01,
                            ),
                            CustomText(
                              text:
                                  '🕐 ${appointment.date}   ${appointment.time}',
                              color: kwhite,
                              fontSize: 22,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  PatientAppointmentDetails(
                    appointment: appointment,
                  ),
                  appointment.status == "Pending"
                      ? AcceptRejectButtons(
                          ref: appointment.ref,
                          registerController: regCtrl,
                          appointment: appointment,
                        )
                      : appointment.status == "Accepted"
                          ? IfAccepted(appointment: appointment)
                          : const ListTile(
                              title: CustomText(
                                text: "Rejected",
                                color: Colors.red,
                              ),
                            )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class IfAccepted extends StatelessWidget {
  final Appointment appointment;
  const IfAccepted({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (appointment.appointmentType == "Online") {
      return ListTile(
        leading: const Icon(
          Icons.video_call,
          size: 30,
          color: primaryColor,
        ),
        title: CustomText(text: appointment.status),
        trailing: CustomButton(
          text: "Copy meeting link",
          ontap: () async {
            try {
              String _url = await FirebaseFirestore.instance
                  .collection("Appointments")
                  .doc(appointment.ref)
                  .get()
                  .then((value) {
                return value.get("meeting_link");
              });

              Clipboard.setData(ClipboardData(text: _url));

              ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                  "Meeting link Copied", Icons.done, primaryColor));
            } catch (e) {
              debugPrint(e.toString());
              ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                  "failed ! please check your internet connection",
                  Icons.done,
                  primaryColor));
            }
          },
        ),
      );
    } else {
      return ListTile(
          leading: const Icon(
            Icons.home,
            color: Colors.blue,
          ),
          title: CustomText(text: appointment.address),
          trailing: const CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.done),
          ));
    }
  }
}

class PatientAppointmentDetails extends StatelessWidget {
  final Appointment appointment;
  const PatientAppointmentDetails({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSize.height * 0.14,
      width: ScreenSize.width,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ListTile(
              leading: StreamBuilder<QuerySnapshot>(
                stream: DatabaseService.getPatientAvatar(appointment.fromUID),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Image.network(
                    snapshot.data?.docs.first.get("profilePic"),
                    fit: BoxFit.cover,
                  );
                },
              ),
              title: CustomText(
                text: appointment.patientName,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              subtitle: CustomText(
                text: "type : " + appointment.appointmentType,
              ),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        SlideTransition1(AppointmentData(
                          appointment: appointment,
                        )));
                  },
                  icon: const Icon(
                    Icons.send,
                    color: primaryColor,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class AcceptRejectButtons extends StatelessWidget {
  final String ref;
  final RegisterController registerController;
  final Appointment appointment;
  const AcceptRejectButtons(
      {Key? key,
      required this.ref,
      required this.registerController,
      required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseService>(
      builder: (context, db, child) {
        return SizedBox(
          height: ScreenSize.height * 0.1,
          width: ScreenSize.width,
          child: Material(
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomButton(
                    ontap: () async {
                      db.acceptAppointment(appointment, context);
                    },
                    radius: ScreenSize.width * 0.05,
                    text: "Accept",
                    width: ScreenSize.width * 0.4),
                CustomButton(
                  ontap: () async {
                    db.rejectAppointment(appointment, context);
                  },
                  radius: ScreenSize.width * 0.05,
                  text: "Reject",
                  width: ScreenSize.width * 0.4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
