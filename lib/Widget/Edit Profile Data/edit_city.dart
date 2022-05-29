import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../../Provider/register_controller.dart';
import '../custom_button.dart';
import '../custom_text.dart';
import '../loading.dart';
import '../snack_bar.dart';

class EditCity extends StatefulWidget {
  const EditCity({Key? key}) : super(key: key);

  @override
  State<EditCity> createState() => _EditCityState();
}

class _EditCityState extends State<EditCity> {
  

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
      builder: (context, regContrller, child) {
        return AlertDialog(
          title: const Center(child: CustomText(text: "Edit City")),
          content: SizedBox(
            height: ScreenSize.height * 0.15,
            width: ScreenSize.width,
            child: isLoading
                ? const LoadingWidget()
                : Center(child: setCity(regContrller)),
          ),
          actions: [
            CustomButton(
              text: "Update",
              ontap: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid;

                try {
                  if (regContrller.city != null || regContrller.city == "") {
                    setState(() {
                      isLoading = true;
                    });
                    await FirebaseFirestore.instance
                        .collection("doctors")
                        .doc(uid)
                        .update({"city": regContrller.city});
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                        "Successfully Updated", Icons.done, primaryColor));
                  }else{
                     ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                        "", Icons.warning, Colors.red));
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
        );
      },
    );
  }
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
          items:
              <String>['Colombo', 'Galle', 'Matara', 'Gampaha'].map((String e) {
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
