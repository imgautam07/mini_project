import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/features/auth/screens/onboarding/onboarding.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  fun() async {
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) {
          return const OnboardingScreen();
        },
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fun();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     AppImages.bgImage,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Positioned.fill(
          //   child: Image.asset(
          //     AppImages.noiseImage,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Align(
          //     alignment: Alignment.center,
          //     child: Image.asset(
          //       'assets/images/logo.png',
          //       width: 176.w,
          //     )),
          Positioned.fill(
            child: Lottie.asset(
              'assets/lottie/splash.json',
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),
        ],
      ),
    );
  }
}
