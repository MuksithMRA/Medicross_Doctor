
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constant/colors.dart';
import '../../Widget/custom_text.dart';
import '../Provider/doctor_controller.dart';
import '../Widget/custom_drawer.dart';

class DoctorHome extends StatelessWidget {
  final int index;
  const DoctorHome({Key? key, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorController>(
      builder: (context, doctorController, child) {
        return Scaffold(
            appBar: customAppBar(doctorController.doctorScreens[index].title),
            drawer: const CustomDrawer(),
            body: doctorController.doctorScreens[index].body);
      },
    );
  }
}

PreferredSize customAppBar(String title) {
  return PreferredSize(
    child: AppBar(
      elevation: 0,
      backgroundColor: primaryColor,
      centerTitle: true,
      title: CustomText(text: title),
      actions: const [
        // IconButton(
        //   onPressed: () {},
        //   icon: Badge(
        //     showBadge: true,
        //     badgeContent: const CustomText(
        //       text: "1",
        //       color: kwhite,
        //     ),
        //     child: const Icon(Icons.notifications),
        //   ),
        // )
      ],
    ),
    preferredSize: const Size.fromHeight(60),
  );
}
