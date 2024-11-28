import 'package:flutter_client/common/buttons/app_%20button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/features/auth/screens/onboarding/onboarding_next.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.bgImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              AppImages.noiseImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
              left: 16.w,
              right: 16.w,
              child: Column(
                children: [
                  const Spacer(),
                  Image.asset(
                    AppImages.logoSquare,
                    height: 143.w,
                    width: 143.w,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Welcome\nto atoon!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50.sp,
                      letterSpacing: -1,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Get connected professionally",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor.withOpacity(.5),
                    ),
                  ),
                  const Spacer(flex: 2),
                  AppButton.fromText(
                    text: "Get Started",
                    icon: Icons.arrow_forward,
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const OnboardingNextScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.w),
                ],
              )),
        ],
      ),
    );
  }
}
