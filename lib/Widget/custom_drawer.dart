import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constant/colors.dart';
import '../../Constant/images.dart';
import '../Model/drawer_tile.dart';
import '../Provider/doctor_controller.dart';
import '../Screen/doctor_home.dart';
import '../Screen/login.dart';
import '../Service/auth.dart';
import 'custom_text.dart';
import 'snack_bar.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [drawerHeader(), const DrawerTileList()],
      ),
    );
  }
}

Widget drawerHeader() {
  FirebaseAuth _auth = FirebaseAuth.instance;
  return UserAccountsDrawerHeader(
    currentAccountPicture:  CircleAvatar(
      backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser?.photoURL??"https://firebasestorage.googleapis.com/v0/b/doctor-app-52b40.appspot.com/o/doctor.jpg?alt=media&token=38a43056-a744-4b1c-8c8a-20ca488fdd9d"),
    ),
    accountName: CustomText(
      text: _auth.currentUser?.displayName ?? "Loading...",
      fontSize: 17,
    ),
    accountEmail: CustomText(
      text: _auth.currentUser?.email ?? "Loading...",
      fontSize: 15,
    ),
  );
}

class DrawerTileList extends StatelessWidget {
  const DrawerTileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctorController =
        Provider.of<DoctorController>(context, listen: true);
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: doctorController.drawerTileData.length,
      itemBuilder: (BuildContext context, int index) {
        final DrawerTile item = doctorController.drawerTileData[index];
        return ListTile(
          onTap: () async {
            if (index != 3) {
              if (index != 2) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return DoctorHome(index: index);
                }));
              } else {
                try {
                  String? result = await AuthService().signOut();
                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                        "Log out failed", Icons.warning, Colors.red));
                  } else {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false,
                    );
                  }
                } catch (e) {
                  debugPrint("Exception : $e");
                }
              }
            } else {
              item.ontap!();
            }
          },
          leading: CircleAvatar(
            backgroundColor: primaryColor,
            child: Icon(item.icon, color: kwhite),
          ),
          title: CustomText(text: item.title),
        );
      },
    );
  }
}
