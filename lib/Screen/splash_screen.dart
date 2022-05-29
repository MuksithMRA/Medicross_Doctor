import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import '../Constant/images.dart';
import '../wrapper.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: logo,
        splashIconSize: MediaQuery.of(context).size.width * 0.8,
        nextScreen: const Wrapper());
  }
}
