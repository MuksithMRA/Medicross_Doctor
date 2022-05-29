import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Constant/colors.dart';
import '../../Constant/images.dart';
import '../../Model/screen_size.dart';
import '../../Widget/custom_text.dart';
import '../Provider/database_service.dart';
import '../Service/storage.dart';
import '../Widget/Edit Profile Data/edit_box.dart';
import '../Widget/Edit Profile Data/edit_city.dart';
import '../Widget/Edit Profile Data/edit_phone.dart';
import '../Widget/Edit Profile Data/show_edit_dialog.dart';
import '../Widget/loading_dialog.dart';
import '../Widget/snack_bar.dart';

class DoctorProfile extends StatelessWidget {
  Stream<DocumentSnapshot> getProfileDetails() async* {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    yield* FirebaseFirestore.instance
        .collection("doctors")
        .doc(uid)
        .snapshots();
  }

  const DoctorProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage();
    return SingleChildScrollView(
      child: StreamBuilder<DocumentSnapshot>(
        stream: getProfileDetails(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return Column(
            children: [
              SizedBox(
                height: ScreenSize.height * 0.28,
                width: ScreenSize.width,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: ScreenSize.width * 0.08),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomText(
                                text: snapshot.data?.get("fullName") ??
                                    "Loading ..",
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: kwhite,
                              ),
                            ],
                          ),
                          CustomText(
                            text: snapshot.data?.get("specialization") ??
                                "Loading ..",
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: kwhite,
                          ),
                        ],
                      ),
                      width: ScreenSize.width,
                      height: ScreenSize.height * 0.2,
                      color: primaryColor,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenSize.width * 0.04),
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image:  DecorationImage(
                                    image: NetworkImage(FirebaseAuth.instance.currentUser?.photoURL??"https://firebasestorage.googleapis.com/v0/b/doctor-app-52b40.appspot.com/o/doctor.jpg?alt=media&token=38a43056-a744-4b1c-8c8a-20ca488fdd9d"),
                                    fit: BoxFit.cover)),
                            height: ScreenSize.height * 0.18,
                            width: ScreenSize.width * 0.38,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.08,
                      width: ScreenSize.width * 0.95,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            child: IconButton(
                                 onPressed: () async {
                          try {
                            final ImagePicker _picker = ImagePicker();
                            // Pick an image
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);

                            if (image?.path != null) {
                              final path = image?.path;
                              final name = image?.name;

                              showLoaderDialog(context);
                              
                              await storage
                                  .uploadFile(path.toString(), name.toString())
                                  .then((value) async {
                                String? url = await storage.getFile().then((value){
                                  return value
                                });

                                DatabaseService.addImageUrl(url??"https://firebasestorage.googleapis.com/v0/b/doctor-app-52b40.appspot.com/o/doctor.jpg?alt=media&token=38a43056-a744-4b1c-8c8a-20ca488fdd9d");
                              });
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  customSnackBar("No Image selected",
                                      Icons.warning, Colors.red));
                            }
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                                icon: const Icon(Icons.add_a_photo)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenSize.height * 0.08,
                      horizontal: ScreenSize.width * 0.05),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.school,
                            color: kwhite,
                          ),
                        ),
                        title: const CustomText(text: "Name"),
                        subtitle: CustomText(
                            text: snapshot.data?.get("fullName") ?? "Loading"),
                        trailing: IconButton(
                            onPressed: () {
                              showEditDialog(
                                  context,
                                  const EditName(
                                    fieldName: "fullName",
                                  ));
                            },
                            icon: const Icon(Icons.edit)),
                      ),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.location_city,
                            color: kwhite,
                          ),
                        ),
                        title: const CustomText(text: "City"),
                        subtitle: CustomText(
                            text: snapshot.data?.get("city") ?? "Loading ..."),
                        trailing: IconButton(
                            onPressed: () {
                              showEditDialog(context, const EditCity());
                            },
                            icon: const Icon(Icons.edit)),
                      ),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.money,
                            color: kwhite,
                          ),
                        ),
                        title: const CustomText(text: "Hourly Rate"),
                        subtitle: CustomText(
                            text:
                                "LKR ${snapshot.data?.get("hourly_rate") ?? "Loading ..."}"),
                        trailing: IconButton(
                            onPressed: () {
                              showEditDialog(
                                  context,
                                  const EditName(
                                    fieldName: "hourly_rate",
                                  ));
                            },
                            icon: const Icon(Icons.edit)),
                      ),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.phone,
                            color: kwhite,
                          ),
                        ),
                        title: const CustomText(text: "Phone number"),
                        subtitle: CustomText(
                            text: snapshot.data?.get("phone") ?? "Loading ??"),
                        trailing: IconButton(
                          onPressed: () {
                            showEditDialog(context, const EditPhone());
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                      // ListTile(
                      //   leading: const CircleAvatar(
                      //     backgroundColor: primaryColor,
                      //     child: Icon(
                      //       Icons.rate_review,
                      //       color: kwhite,
                      //     ),
                      //   ),
                      //   title: const CustomText(text: "Rating"),
                      //   subtitle: ratingBar(double.parse(
                      //       snapshot.data?.get("ratingCount") ?? 0.toString())),
                      //   trailing: CustomText(
                      //       text:
                      //           snapshot.data?.get("reviewCount").toString() ??
                      //               "Loading ??"),
                      // )
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }
}
