import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicross_doctor/Model/appointment.dart';
import 'package:medicross_doctor/Widget/appointment_card.dart';

import '../Widget/custom_text.dart';
import '../Widget/loading.dart';

class Appointments extends StatelessWidget {
  Stream<QuerySnapshot> getAllAppointments(BuildContext context) async* {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    yield* FirebaseFirestore.instance
        .collection("Appointments")
        .where('toUID', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  const Appointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getAllAppointments(context),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasData) {
            int length = snapshot.data?.docs.length ?? 0;
            if (length != 0) {
              return ListView.builder(
                itemCount: length,
                itemBuilder: (BuildContext context, int index) {
                  var item = snapshot.data?.docs[index];
                  debugPrint(
                      snapshot.data?.docs[index].reference.id.toString());
                  return AppointmentCard(
                    appointment: Appointment(
                      address: item?.get('address'),
                        ref: snapshot.data?.docs[index].reference.id
                                .toString() ??
                            "",
                        doctorName: item?.get("doctorName"),
                        createdAt: item?.get("createdAt"),
                        appointmentType: item?.get("AppointmentType"),
                        fromUID: item?.get("fromUID"),
                        toUID: item?.get("toUID"),
                        date: item?.get("Date"),
                        time: item?.get("Time"),
                        note: item?.get("Note"),
                        status: item?.get("Status"),
                        totalFee: double.parse(item?.get("totalFee")),
                        patientName: item?.get("patientName"),
                        patientAge: item?.get("patientAge")),
                  );
                },
              );
            } else {
              return const Center(
                child: CustomText(text: "No Appointments"),
              );
            }
          }
          return Center(
            child: CustomText(
              text: snapshot.error.toString(),
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
