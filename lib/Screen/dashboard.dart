import 'package:flutter/material.dart';
import '../../Constant/colors.dart';

import '../../Model/screen_size.dart';
import '../../Widget/custom_text.dart';
import '../Model/doctor_dashboard_tile.dart';

class DoctorDashBoard extends StatelessWidget {
  const DoctorDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(
        //       horizontal: ScreenSize.width * 0.05,
        //       vertical: ScreenSize.height * 0.03),
        //   child: const NoticeBoard(),
        // ),
        const DoctorDashBoardHeadings(),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.width * 0.05,
          ),
          child: const Counts(),
        ),
      ],
    );
  }
}

class Counts extends StatelessWidget {
  const Counts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSize.height * 0.8,
      child: Column(
        children: [
          Container(
            height: ScreenSize.height * 0.39,
            color: Colors.red,
            child: Column(
              
            ),
          ),
          SizedBox(
            height: ScreenSize.height * 0.01,
          ),
          Container(
            height: ScreenSize.height * 0.39,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final DoctorDashboardTile dashboardTile;
  final bool isNotCount;
  const DashboardTile(
      {Key? key, required this.dashboardTile, required this.isNotCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(text: dashboardTile.heading, color: kwhite, fontSize: 15),
          const SizedBox(
            height: 10,
          ),
          CustomText(
              text: isNotCount
                  ? "Rs " + dashboardTile.count.toString()
                  : dashboardTile.count.toString(),
              color: kwhite,
              fontSize: 25),
        ],
      ),
    );
  }
}

class DoctorDashBoardHeadings extends StatelessWidget {
  const DoctorDashBoardHeadings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: CustomText(text: ""),
    );
  }
}

// class NoticeBoard extends StatelessWidget {
//   Stream<QuerySnapshot> getAppointments(BuildContext context) async* {
//     yield* FirebaseFirestore.instance
//         .collection("Appointments")
//         .where('toUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .snapshots();
//   }

//   const NoticeBoard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: ScreenSize.height * 0.3,
//       width: ScreenSize.width,
//       child: Material(
//         borderRadius: BorderRadius.circular(25),
//         color: kwhite,
//         elevation: 5,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Expanded(
//                 child: CustomText(
//                   textAlign: TextAlign.start,
//                   text: "Upcoming Patient",
//                   color: primaryColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                 ),
//               ),
//               Expanded(
//                 flex: 4,
//                 child: SizedBox(
//                   width: ScreenSize.width,
//                   child: StreamBuilder(
//                     stream: getAppointments(context),
//                     builder: (BuildContext context, AsyncSnapshot snapshot) {

//                       return Row(
//                         children: const [
//                           Flexible(child: UpcomingPatient()),
//                           Flexible(
//                             flex: 2,
//                             child: PatientDetails(),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class UpcomingPatient extends StatelessWidget {
//   const UpcomingPatient({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           CustomText(
//             text: "2022",
//             color: kwhite,
//           ),
//           CustomText(
//             text: "03/15",
//             fontSize: 17,
//             color: kwhite,
//           ),
//           CustomText(
//             text: "04",
//             fontSize: 33,
//             color: kwhite,
//           ),
//           CustomText(
//             text: "30",
//             fontSize: 33,
//             color: kwhite,
//           ),
//           CustomText(
//             text: "AM",
//             color: kwhite,
//             fontSize: 25,
//           )
//         ],
//       ),
//       decoration: const BoxDecoration(
//         color: primaryColor,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20),
//         ),
//       ),
//     );
//   }
// }

// class PatientDetails extends StatelessWidget {
//   const PatientDetails({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: const [
//               CircleAvatar(
//                 backgroundImage: AssetImage(patientImg),
//                 radius: 30,
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           const CustomText(
//             text: "John Doe",
//             fontWeight: FontWeight.bold,
//             fontSize: 25,
//           ),
//           const CustomText(
//             text: "✈ De mel Road , Colombo",
//             fontSize: 17,
//           ),
//           const CustomText(
//             text: "Online consultation",
//             fontSize: 17,
//           ),
//         ],
//       ),
//     );
//   }
// }
