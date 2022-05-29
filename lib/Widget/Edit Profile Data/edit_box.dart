import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../../Provider/validations.dart';
import '../custom_button.dart';
import '../custom_text.dart';
import '../custom_textfield.dart';
import '../loading.dart';
import '../snack_bar.dart';

class EditName extends StatefulWidget {
  final String fieldName;
  const EditName({Key? key, required this.fieldName}) : super(key: key);

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  final _txtEdit = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Center(
            child: CustomText(
                text:
                    "Edit  ${widget.fieldName == "fullName" ? "Full Name" : widget.fieldName}")),
        content: SizedBox(
          height: ScreenSize.height * 0.15,
          width: ScreenSize.width,
          child: isLoading
              ? const LoadingWidget()
              : Center(
                  child: CustomTextField(
                    keyboardType: widget.fieldName == 'hourly_rate'
                        ? TextInputType.number
                        : null,
                    validator: (val) {
                      switch (widget.fieldName) {
                        case 'fullName':
                          return ValidationController.isFullNameValid(val);

                        case 'hourly_rate':
                          return ValidationController.isHourlyRateValid(val);
                      }
                      return null;
                    },
                    controller: _txtEdit,
                    prefixIcon: Icons.edit,
                    hintText: widget.fieldName == "fullName"
                        ? "Full Name"
                        : widget.fieldName == 'hourly_rate'
                            ? "Hourly Rate"
                            : null,
                  ),
                ),
        ),
        actions: [
          CustomButton(
            text: "Update",
            ontap: () async {
              if (_formKey.currentState!.validate()) {
                final uid = FirebaseAuth.instance.currentUser?.uid;

                try {
                  setState(() {
                    isLoading = true;
                  });
                  await FirebaseFirestore.instance
                      .collection("doctors")
                      .doc(uid)
                      .update({widget.fieldName: _txtEdit.text.trim()});
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      "Successfully Updated", Icons.done, primaryColor));
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      "Failed to Update", Icons.warning, Colors.red));
                }
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
  }
}
