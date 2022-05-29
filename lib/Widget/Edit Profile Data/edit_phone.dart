import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../../Provider/register_controller.dart';
import '../../Provider/validations.dart';
import '../custom_button.dart';
import '../custom_text.dart';
import '../custom_textfield.dart';
import '../loading.dart';
import '../snack_bar.dart';

class EditPhone extends StatefulWidget {
  const EditPhone({Key? key}) : super(key: key);

  @override
  State<EditPhone> createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> {
  final _formKEy = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
      builder: (context, regContrller, child) {
        return Form(
          key: _formKEy,
          child: AlertDialog(
            title: const Center(child: CustomText(text: "Edit City")),
            content: SizedBox(
              height: ScreenSize.height * 0.15,
              width: ScreenSize.width,
              child: isLoading
                  ? const LoadingWidget()
                  : Center(child: phoneNumber(regContrller)),
            ),
            actions: [
              CustomButton(
                text: "Update",
                ontap: () async {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
        
                  try {
                    if (regContrller.phoneNumber != null || regContrller.phoneNumber != "") {
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseFirestore.instance
                          .collection("doctors")
                          .doc(uid)
                          .update({"phone": regContrller.phoneNumber});
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                          "Successfully Updated", Icons.done, primaryColor));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar("Please enter phone number", Icons.warning, Colors.red));
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                        "Failed to Update", Icons.warning, Colors.red));
                  }
                },
              ),
              CustomButton(
                text: "Cancel",
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

Widget phoneNumber(RegisterController regcontroller) {
  return SizedBox(
    width: ScreenSize.width,
    child: Row(
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
            flex: 4,
            child: CustomTextField(
              isUnderlineField: true,
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
    ),
  );
}
