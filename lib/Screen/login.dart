import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constant/colors.dart';
import '../../Constant/images.dart';
import '../../Model/screen_size.dart';
import '../../Widget/custom_text.dart';
import '../../Widget/custom_textfield.dart';
import '../../Widget/push_screen.dart';
import '../Provider/error_provider.dart';
import '../Provider/login_ controller.dart';
import '../Provider/validations.dart';
import '../Service/auth.dart';
import '../Widget/custom_button.dart';
import '../Widget/loading_dialog.dart';
import '../Widget/snack_bar.dart';
import 'forgot_password.dart';
import 'register.dart';
import 'verify_email.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, loginCtrl, child) {
        return Scaffold(
            body: loginCtrl.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.width * 0.05),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: ScreenSize.height * 0.1,
                            ),
                            SizedBox(
                              height: ScreenSize.height * 0.3,
                              child: Image.asset(
                                logo,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: ScreenSize.height * 0.035,
                            ),
                            CustomTextField(
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                                validator: (val) {
                                  return ValidationController.isEmailValidated(
                                      val);
                                },
                                prefixIcon: Icons.mail,
                                labelText: "Email"),
                            SizedBox(
                              height: ScreenSize.height * 0.03,
                            ),
                            CustomTextField(
                                isPassword: true,
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                                validator: (val) {
                                  return ValidationController
                                      .isNewPassValidated(val);
                                },
                                prefixIcon: Icons.lock,
                                labelText: "Password"),
                            SizedBox(
                              height: ScreenSize.height * 0.04,
                            ),
                            CustomButton(
                              ontap: () async {
                                if (_formKey.currentState!.validate()) {
                                  showLoaderDialog(context);
                                  await AuthService()
                                      .signInWithEmailAndPassword(
                                          email!, password!)
                                      .then((value) async {
                                    Navigator.pop(context);
                                    if (value != null) {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (_) {
                                        return const VerifyEmail();
                                      }));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        customSnackBar(ErrorProvider.message,
                                            Icons.warning, Colors.red),
                                      );
                                    }
                                  });
                                }
                              },
                              text: "Log in",
                              width: ScreenSize.width,
                            ),
                            forgotPassword(context),
                            registerRedirect(
                              context: context,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
      },
    );
  }
}

//==========================================================================
//Register Redirect

Widget registerRedirect({required BuildContext context}) {
  return Column(
    children: [
      SizedBox(
        height: ScreenSize.height * 0.19,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomText(
            text: "Don't you have an account? ",
            fontWeight: FontWeight.w300,
            fontSize: 17,
          ),
          CustomText(
            onTap: () {
              Routes.pushScreen(
                ctx: context,
                widget: const Register(),
              );
            },
            text: "Signup",
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: primaryColor,
          ),
        ],
      ),
    ],
  );
}

//=====================================================================
Widget forgotPassword(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: ScreenSize.height * 0.03,
      ),
      CustomText(
        onTap: () {
          Routes.pushScreen(
            ctx: context,
            widget: const ForgotPassword(),
          );
        },
        text: "Forgot Password? ",
        fontWeight: FontWeight.w300,
        fontSize: 17,
      ),
    ],
  );
}
