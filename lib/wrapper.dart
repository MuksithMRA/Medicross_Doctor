import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicross_doctor/Screen/doctor_home.dart';
import 'package:medicross_doctor/Screen/login.dart';
import 'package:provider/provider.dart';
import 'Model/screen_size.dart';
import 'Provider/login_ controller.dart';
import 'Screen/verify_email.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    ScreenSize.setScreenSize(h: screenSize.height, w: screenSize.width);

    return Consumer<LoginController>(
      builder: (context, loginCtrl, child) {
        loginCtrl.setLoginState();

        if (loginCtrl.isLoggedIn) {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            return const DoctorHome();
          } else {
            return const VerifyEmail();
          }
        } else {
          return const Login();
        }
      },
    );
  }
}
