import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/appointment.dart';
import '../Model/notification.dart';
import '../Widget/Edit Profile Data/show_edit_dialog.dart';
import '../Widget/add_meeting.dart';
import '../Widget/snack_bar.dart';

class DatabaseService extends ChangeNotifier {
  String? phonenum;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();

  //get Phone number
  Future<void> getPhoneNum(String uid) async {
    phonenum = await _firestore
        .collection("patients")
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot snapshot) {
          return snapshot.docs.first.get('phone');
        })
        .whenComplete(() => debugPrint(phonenum))
        .catchError((error, stackTrace) {
          debugPrint("$error");
        });
  }

  //Accept Appointment
  Future<void> acceptAppointment(
      Appointment appointment, BuildContext context) async {
    if (appointment.appointmentType == "Home visit") {
      try {
        var firestore = FirebaseFirestore.instance;
        await firestore
            .collection("Appointments")
            .doc(appointment.ref)
            .update({"Status": "Accepted"}).whenComplete(() async {
          await sendNotification(
            NotificationModel(
              content: "From : ${_auth.currentUser?.displayName}",
              createdAt: DateFormat('dd/MM/yyyy, kk:mm').format(now),
              fromUID: appointment.toUID,
              toUID: appointment.fromUID,
              heading: "Appointment Accepted",
              isRead: false,
            ),
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar("Something went wrong", Icons.warning, Colors.red));
      }
    } else {
      showEditDialog(
        context,
        AddMeeting(
          ref: appointment.ref,
        ),
      );
    }
  }

  //Reject Appointment
  Future<void> rejectAppointment(
      Appointment appointment, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("Appointments")
          .doc(appointment.ref)
          .update({"Status": "Rejected"}).whenComplete(() async {
        await sendNotification(
          NotificationModel(
              content: "From : ${_auth.currentUser?.displayName}",
              createdAt: DateFormat('dd/MM/yyyy, kk:mm').format(now),
              fromUID: appointment.toUID,
              toUID: appointment.fromUID,
              heading: "Appointment Rejected",
              isRead: false,
              ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
          "failed check your internet connection", Icons.warning, Colors.red));
    }
  }

//Send notification
  Future<void> sendNotification(NotificationModel notification) async {
    await _firestore
        .collection("Notifications")
        .add(notification.toMap())
        .then((value) => debugPrint("success"))
        .catchError((error, stackrace) {
      debugPrint("notification sending unsuccess");
    });
  }

  static Future<bool?> isDoctor() async {
    bool? isAdmin = await _firestore
        .collection('doctors')
        .get()
        .then((QuerySnapshot snapshot) {
      for (var a in snapshot.docs) {
        if (a.get('uid') == _auth.currentUser?.uid) {
          return true;
        } else {
          return false;
        }
      }
      return null;
    }).catchError((error, stackrace) {
      debugPrint(stackrace);
      return false;
    });

    return isAdmin;
  }


  static Stream<QuerySnapshot> getPatientAvatar(String patientUID) async* {
    yield* _firestore
        .collection("patients")
        .where('uid', isEqualTo: patientUID)
        .snapshots();
        
  }

  static Future<void> addImageUrl(String url) async {
    await _auth.currentUser?.updatePhotoURL(url).then((value) async {
      await _firestore
          .collection('doctors')
          .doc(_auth.currentUser?.uid)
          .update({"profilePic": url});
    }).catchError((error, stackrace) {
      debugPrint(stackrace);
    });
  }

  static Future<String> getImage() async {
    String url = await _firestore
        .collection('doctors')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((value) {
      return value.get("profilePic");
    });

    return url;
  }
}
