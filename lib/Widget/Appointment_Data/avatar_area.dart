import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constant/colors.dart';
import '../../Model/appointment.dart';
import '../../Model/screen_size.dart';
import '../../Provider/database_service.dart';
import '../custom_circle.dart';

class AvatarArea extends StatelessWidget {
  final Appointment appointment;
  const AvatarArea({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseService>(
      builder: (context, db, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService.getPatientAvatar(appointment.fromUID),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CustomCircle(
                        radius: ScreenSize.width * 0.17,
                        widget: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return CustomCircle(
                      radius: ScreenSize.width * 0.17,
                      img: NetworkImage(snapshot.data?.docs.first.get("profilePic"))
                    );
                  },
                ),
                SizedBox(
                  width: ScreenSize.width * 0.08,
                ),
                CustomCircle(
                  widget: IconButton(
                    onPressed: () async {
                      await db.getPhoneNum(appointment.fromUID);
                      String url = "tel:${db.phonenum}";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        debugPrint("Could not launch $url");
                      }
                    },
                    icon: const Icon(
                      Icons.phone,
                      color: kwhite,
                    ),
                  ),
                  radius: 40,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
