import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicross_doctor/Screen/doctor_home.dart';
import 'package:provider/provider.dart';
import '../Model/screen_size.dart';
import '../Provider/register_controller.dart';
import '../Provider/validations.dart';
import '../Service/auth.dart';
import '../Widget/custom_button.dart';
import '../Widget/custom_text.dart';
import '../Widget/custom_textfield.dart';
import '../Widget/loading.dart';
import 'login.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
    }
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  @override
  void dispose() {
    timer!.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const DoctorHome()
        : Scaffold(
            appBar: AppBar(
              title: const CustomText(text: "Verify your email"),
              centerTitle: true,
            ),
            body: SizedBox(
              width: ScreenSize.width,
              height: ScreenSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomText(
                    text: "Verification email sent to your email",
                    fontSize: 20,
                  ),
                  CustomText(
                    text: FirebaseAuth.instance.currentUser?.email ??
                        "Loading ..",
                    fontSize: 15,
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.05,
                  ),
                  CustomButton(
                    text: "Resend",
                    width: ScreenSize.width * 0.8,
                    ontap: () async {
                      await sendVerificationEmail();
                    },
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.02,
                  ),
                  CustomButton(
                    text: "Change Email Address",
                    width: ScreenSize.width * 0.8,
                    ontap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return ChangeEmailBox(
                                sendVerificationEmail: sendVerificationEmail());
                          });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () async {
                        try {
                          timer?.cancel();
                          await AuthService().signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (Route<dynamic> route) => false,
                          );
                        } catch (e) {
                          debugPrint("$e");
                        }
                      },
                      child: const CustomText(text: "Cancel"))
                ],
              ),
            ),
          );
  }
}

class ChangeEmailBox extends StatefulWidget {
  final Future<dynamic> sendVerificationEmail;
  const ChangeEmailBox({Key? key, required this.sendVerificationEmail})
      : super(key: key);

  @override
  State<ChangeEmailBox> createState() => _ChangeEmailBoxState();
}

class _ChangeEmailBoxState extends State<ChangeEmailBox> {
  final _changeMail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _changeMail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
      builder: (context, regCtrl, child) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: const Center(child: CustomText(text: "Change Email")),
            content: SizedBox(
              height: ScreenSize.height * 0.2,
              width: ScreenSize.width,
              child: regCtrl.isLoading
                  ? const LoadingWidget()
                  : Center(
                      child: CustomTextField(
                        hintText: "New Email address",
                        controller: _changeMail,
                        validator: (val) {
                          return ValidationController.isEmailValidated(val);
                        },
                        prefixIcon: Icons.mail,
                      ),
                    ),
            ),
            actions: [
              CustomButton(
                text: "Change",
                ontap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      regCtrl.onLoadingChanged(true);
                      await FirebaseAuth.instance.currentUser!
                          .updateEmail(_changeMail.text.trim());
                      await FirebaseFirestore.instance
                          .collection("doctors")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({"email": _changeMail.text.trim()});
                      await widget.sendVerificationEmail;
                      Navigator.pop(context);
                      regCtrl.onLoadingChanged(false);
                    } catch (e) {
                      debugPrint(e.toString());
                      regCtrl.onLoadingChanged(false);
                    }
                  }
                },
              ),
              CustomButton(
                text: "Cancel",
                ontap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
