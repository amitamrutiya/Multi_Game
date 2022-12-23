import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_game/dimention.dart';
import 'package:multi_game/main_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        backgroundColor: Dimensions.mainColor,
        splash: Lottie.asset('assets/spalsh_animation.json'),
        nextScreen: const HomePage(),
        splashIconSize: 500,
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,

        // pageTransitionType: PageTransitionType.leftToRightwithFade,
        animationDuration: const Duration(seconds: 1),
      ),
    );
  }
}
