import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicross_doctor/Model/screen_size.dart';
import 'package:medicross_doctor/Provider/register_controller.dart';
import 'package:medicross_doctor/Provider/validations.dart';
import 'package:medicross_doctor/Widget/custom_button.dart';
import 'package:medicross_doctor/Widget/custom_text.dart';
import 'package:medicross_doctor/Widget/custom_textfield.dart';
import 'package:medicross_doctor/Widget/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddMeeting extends StatefulWidget {
  final String ref;
  const AddMeeting({Key? key, required this.ref}) : super(key: key);

  @override
  State<AddMeeting> createState() => _AddMeetingState();
}

class _AddMeetingState extends State<AddMeeting> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
      builder: (context, regCtrl, child) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: const Center(
              child: CustomText(text: "Add Meeting link"),
            ),
            content: SizedBox(
              height: ScreenSize.height * 0.2,
              width: ScreenSize.width,
              child: Center(
                child: CustomTextField(
                  prefixIcon: Icons.video_call,
                  hintText: 'Meeting link',
                  validator: (val) {
                    return ValidationController.isZoomLinkValid(val);
                  },
                  onChanged: (val) {
                    regCtrl.setZoomLink(value: val);
                  },
                ),
              ),
            ),
            actions: [
              CustomButton(
                text: "Add",
                ontap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      var firestore = FirebaseFirestore.instance;
                      if (regCtrl.zoomLink != null || regCtrl.zoomLink == "") {
                        await firestore
                            .collection("Appointments")
                            .doc(widget.ref)
                            .update({"Status": "Accepted"}).whenComplete(() {
                          firestore
                              .collection("Appointments")
                              .doc(widget.ref)
                              .update({"meeting_link": regCtrl.zoomLink});
                        }).whenComplete(() async {
                          firestore.collection("Notifications").add({
                            "content":
                                "From : ${FirebaseAuth.instance.currentUser!.displayName}",
                            "createdAt": DateFormat('dd/MM/yyyy, kk:mm')
                                .format(DateTime.now()),
                            "fromUID": FirebaseAuth.instance.currentUser!.uid,
                            "heading": "Appointment Accepted",
                            "toUID": await firestore
                                .collection("Appointments")
                                .doc(widget.ref)
                                .get()
                                .then((value) => value.get("fromUID"))
                          });
                        });
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                          "failed check your internet connection",
                          Icons.warning,
                          Colors.red));
                    }
                  }
                },
              ),
              CustomButton(
                text: "Close",
                ontap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
