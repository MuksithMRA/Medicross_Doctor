


import 'package:medicross_doctor/Provider/database_service.dart';
import 'package:medicross_doctor/Provider/register_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'doctor_controller.dart';
import 'login_ controller.dart';

List<SingleChildWidget> providers = [
  
  ChangeNotifierProvider<RegisterController>(
    create: (context) => RegisterController(),
  ),
 
  ChangeNotifierProvider<LoginController>(
    create: (context) => LoginController(),
  ),
 
  ChangeNotifierProvider<DoctorController>(
    create: (context) => DoctorController(),
  ),
  ChangeNotifierProvider<DatabaseService>(
    create: (context) => DatabaseService(),
  ),
  
];
