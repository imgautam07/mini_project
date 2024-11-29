import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/manager/local_manager.dart';
import 'package:flutter_client/features/auth/screens/onboarding/onboarding.dart';
import 'package:flutter_client/features/auth/screens/profile_complete/questions_screen.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/home/provider/post_provider.dart';
import 'package:flutter_client/features/projects/provider/project_provider.dart';
import 'package:flutter_client/features/root_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  fun() async {
    await Future.delayed(const Duration(seconds: 4));

    var token = await LocalDataManager.getToken();

    var r2 = false;

    if (token != null && mounted) {
      r2 = await Provider.of<AuthServices>(context, listen: false)
          .accountStatus();

      if (r2 && mounted) {
        await Provider.of<PostProvider>(context, listen: false).fetchPosts();
        if (mounted) {
          await Provider.of<ProjectProvider>(context, listen: false)
              .fetchProjects();
        }
      }
    }

    if (mounted) {
      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) {
          if (token == null) {
            return const OnboardingScreen();
          } else {
            if (r2) {
              return const RootScreen();
            }
            return const QuestionsScreen();
          }
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
