import 'dart:io';
import 'package:flutter/material.dart';

import '../Model/doctor_dashboard_tile.dart';
import '../Model/doctor_profile_list_tile.dart';
import '../Model/doctor_screen_model.dart';
import '../Model/drawer_tile.dart';
import '../Screen/appointments.dart';
import '../Screen/doctor_profile.dart';

class DoctorController extends ChangeNotifier {
  List<DrawerTile> drawerTileData = [
    DrawerTile(icon: Icons.schedule, title: "Appointments"),
    DrawerTile(icon: Icons.person, title: "My Profile"),
    DrawerTile(
        icon: Icons.logout,
        title: "Log out",
        ontap: () {
          //FirebaseAuth.instance.signOut();
        }),
    DrawerTile(
      icon: Icons.exit_to_app,
      title: "Exit",
      ontap: () {
        exit(0);
      },
    ),
  ];

  List<DoctorScreenModel> doctorScreens = [
    DoctorScreenModel(title: "Appointments", body: const Appointments()),
    DoctorScreenModel(title: "My Profile", body: const DoctorProfile()),
  ];

  List<DoctorDashboardTile> dashboardTiles = [
    DoctorDashboardTile(heading: "Total Patients", count: 210),
    DoctorDashboardTile(heading: "Total Earning", count: 20000),
    DoctorDashboardTile(heading: "Today Patients", count: 10),
    DoctorDashboardTile(heading: "Today Earning", count: 10000),
  ];

  List<DoctorProfileListTile> doctorProfileTile = [
    DoctorProfileListTile(
        icon: Icons.school, title: "Specialization", subTitle: "Dentist"),
    DoctorProfileListTile(
        icon: Icons.mail, title: "Email", subTitle: "doctor@gmail.com"),
  
    DoctorProfileListTile(
        icon: Icons.money_rounded,
        title: "Manage Bank Details",
        subTitle: "8270045687"),
    DoctorProfileListTile(
        icon: Icons.lock, title: "Manage Password", subTitle: "********"),
  ];
}
