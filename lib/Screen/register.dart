import 'package:flutter/material.dart';
import 'package:medicross_doctor/Widget/snack_bar.dart';
import 'package:provider/provider.dart';
import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../../Widget/custom_button.dart';
import '../../Widget/custom_text.dart';
import '../../Widget/custom_textfield.dart';
import '../../Widget/push_screen.dart';
import '../Provider/error_provider.dart';
import '../Provider/register_controller.dart';
import '../Provider/validations.dart';
import '../Service/auth.dart';
import '../Widget/loading_dialog.dart';
import 'login.dart';
import 'verify_email.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
      builder: (context, regcontroller, child) {
        return Scaffold(
          body: regcontroller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: BackButton(),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.03,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenSize.width * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headMain(),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),
                                headSub(context),
                                SizedBox(
                                  height: ScreenSize.height * 0.04,
                                ),

                                //Full Name
                                CustomTextField(
                                  prefixIcon: Icons.person,
                                  labelText: "Full Name",
                                  onChanged: (String? value) {
                                    regcontroller.setFullName(value: value);
                                  },
                                  validator: (val) {
                                    return ValidationController.isFullNameValid(
                                        val);
                                  },
                                ),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                //Email
                                CustomTextField(
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.mail,
                                  labelText: "Email",
                                  onChanged: (String? value) {
                                    regcontroller.setEmail(value: value);
                                  },
                                  validator: (val) {
                                    return ValidationController
                                        .isEmailValidated(val);
                                  },
                                ),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                //Select City
                                setCity(regcontroller),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                //Select phone number
                                phoneNumber(regcontroller),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                CustomTextField(
                                  keyboardType: TextInputType.number,
                                  hintText: 'In LKR',
                                  onChanged: (String? value) {
                                    regcontroller.setHourlyRate(value: value);
                                  },
                                  validator: (val) {
                                    return ValidationController.isZoomLinkValid(
                                        val);
                                  },
                                  prefixIcon: Icons.money,
                                  labelText: "Hourly Rate",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                //Doctor Specialization
                                doctorSpecialization(regcontroller),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                //New Password
                                CustomTextField(
                                  isPassword: true,
                                  onChanged: (String? value) {
                                    regcontroller.setnewPassword(value: value);
                                  },
                                  validator: (val) {
                                    return ValidationController
                                        .isNewPassValidated(val);
                                  },
                                  prefixIcon: Icons.lock_open,
                                  labelText: "New Password",
                                ),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                //Confirm Password
                                CustomTextField(
                                    isPassword: true,
                                    validator: (val) {
                                      return ValidationController
                                          .isConfirmPassValidated(
                                              regcontroller.newPassword, val);
                                    },
                                    onChanged: (String? value) {
                                      regcontroller.setConfirmPassword(
                                          value: value);
                                    },
                                    prefixIcon: Icons.lock,
                                    labelText: "Confirm Password"),
                                SizedBox(
                                  height: ScreenSize.height * 0.05,
                                ),

                                //Register Button
                                CustomButton(
                                  ontap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (regcontroller.specialization ==
                                              null ||
                                          regcontroller
                                              .specialization!.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(customSnackBar(
                                                "Please select a specialization",
                                                Icons.warning,
                                                Colors.red));
                                      } else if (regcontroller.city == null ||
                                          regcontroller.city!.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(customSnackBar(
                                                "Please select a city",
                                                Icons.warning,
                                                Colors.red));
                                      } else {
                                    
                                        AuthService _auth = AuthService();
                                       
                                        showLoaderDialog(context);
                                        String? result = await _auth
                                            .signUpWithEmailAndPassword(
                                                regcontroller
                                                    .onRegister(context));
                                       
                                        Navigator.pop(context);
                                        if (result == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(customSnackBar(
                                                  ErrorProvider.message,
                                                  Icons.warning,
                                                  Colors.red));
                                        } else {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const VerifyEmail()),
                                            (Route<dynamic> route) => false,
                                          );
                                        }
                                      }
                                    }
                                  },
                                  text: "Register",
                                  width: ScreenSize.width,
                                ),
                                SizedBox(height: ScreenSize.height * 0.01),
                                const CustomText(
                                  text:
                                      "By clicking Register you are agreeing to the Terms of use and the Privacy Policy",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget setCity(RegisterController registerController) {
    return Row(
      children: [
        const Flexible(
          child: CustomText(
            text: "Select City ",
            fontSize: 18,
          ),
        ),
        SizedBox(
          width: ScreenSize.width * 0.1,
        ),
        Flexible(
          child: DropdownButton<String>(
            value: registerController.city ?? "Colombo",
            items: <String>['Colombo', 'Galle', 'Matara', 'Gampaha']
                .map((String e) {
              return DropdownMenuItem(
                  value: e,
                  child: CustomText(
                    fontSize: 18,
                    text: e.toString(),
                  ));
            }).toList(),
            onChanged: (String? val) {
              registerController.setCity(val);
            },
          ),
        ),
      ],
    );
  }

  Widget doctorSpecialization(RegisterController regcontroller) {
    return Row(
      children: [
        const Flexible(
          child: CustomText(
            text: "Specialization",
            fontSize: 18,
          ),
        ),
        SizedBox(
          width: ScreenSize.width * 0.1,
        ),
        Flexible(
          child: DropdownButton<String>(
            value: regcontroller.specialization ?? "Dentist",
            items: <String>[
              'Dentist',
              'Dermatology',
              'Anesthesiology',
              'Family medicine',
              'Neurology',
              'Psychiatry',
              'Pathology'
            ].map((String e) {
              return DropdownMenuItem(
                  value: e,
                  child: CustomText(
                    fontSize: 18,
                    text: e.toString(),
                  ));
            }).toList(),
            onChanged: (String? val) {
              regcontroller.setSpecialization(val);
            },
          ),
        ),
      ],
    );
  }

  Widget headMain() {
    return const CustomText(
      text: "Welcome to Medical Cross App",
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );
  }

  Widget headSub(BuildContext context) {
    return Row(
      children: [
        const CustomText(
          text: "Already have an account? ",
          fontSize: 16,
        ),
        CustomText(
          text: "Log In",
          onTap: () {
            Routes.pushScreen(ctx: context, widget: const Login());
          },
          color: primaryColor,
          fontSize: 16,
        )
      ],
    );
  }

  Widget phoneNumber(RegisterController regcontroller) {
    return Row(
      children: [
        Flexible(
          child: DropdownButton<String>(
            value: regcontroller.countryCode ?? "+94",
            items: <String>['+94', '+91', '+1'].map((String e) {
              return DropdownMenuItem(
                  value: e,
                  child: CustomText(
                    fontSize: 18,
                    text: e.toString(),
                  ));
            }).toList(),
            onChanged: (String? val) {
              regcontroller.onChangeCountryCode(val: val);
            },
          ),
        ),
        Flexible(
            flex: 5,
            child: CustomTextField(
                keyboardType: TextInputType.phone,
                validator: (val) {
                  return ValidationController.isPhoneNumberValid(val);
                },
                onChanged: (String? value) {
                  regcontroller.setPhone(value: value);
                },
                prefixIcon: Icons.phone,
                labelText: "Phone Number")),
      ],
    );
  }
}
