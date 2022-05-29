import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/screen_size.dart';
import '../Provider/login_ controller.dart';
import '../Provider/validations.dart';
import '../Widget/custom_button.dart';
import '../Widget/custom_text.dart';
import '../Widget/custom_textfield.dart';
import '../Widget/loading.dart';
import '../Widget/snack_bar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _txtForgot = TextEditingController();
  Image? img;

  

  @override
  void dispose() {
    _txtForgot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, loginCtrl, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const CustomText(text: "Forgot Password"),
          ),
          body: loginCtrl.isLoading
              ? const LoadingWidget()
              : Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        CustomTextField(
                          controller: _txtForgot,
                          validator: (val) {
                            return ValidationController.isEmailValidated(val);
                          },
                          hintText: 'Enter your email',
                          prefixIcon: Icons.mail,
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.03,
                        ),
                        CustomButton(
                          width: ScreenSize.width,
                          text: "Reset Password",
                          ontap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                loginCtrl.onLoadingChanged(true);
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: _txtForgot.text.trim());
                                loginCtrl.onLoadingChanged(false);

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackBar("Password reset email sent",
                                        Icons.done, Colors.blue));
                              } catch (e) {
                                loginCtrl.onLoadingChanged(false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackBar("Something went wrong",
                                        Icons.warning, Colors.red));
                              }
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
