import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/features/profile/screens/achievement_screen.dart';
import 'package:flutter_client/features/profile/screens/settings/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + 16.h),
          Row(
            children: [
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
                icon: Image.asset(
                  AppImages.settings,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/profile.png',
                              width: 80.w,
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gautam Yadav",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "gaut....@gmail.com | Developer",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          AppColors.textColor.withOpacity(.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      _valueCard(title: "Projects", value: "12"),
                      SizedBox(width: 8.w),
                      _valueCard(title: "Works", value: "48H"),
                      // SizedBox(width: 8.w),
                      // _valueCard(title: "Days", value: "2"),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  ScaleButton(
                    scale: .99,
                    onTap: () {},
                    child: Container(
                      height: 110.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6448B1),
                        borderRadius: BorderRadius.circular(32),
                        image: DecorationImage(
                          image: AssetImage(AppImages.noiseImage),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.8),
                            blurRadius: 35,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                AppImages.promoBg,
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
                              top: 24.h,
                              bottom: 24.h,
                              left: 24.w,
                              right: 24.w,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Share the magic",
                                          style: TextStyle(
                                            fontSize: 26.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Give a free 14-day trial to a friend",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    AppImages.gradientForwardButton,
                                    width: 45.w,
                                    height: 45.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Achievements",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      /// background: linear-gradient(90deg, #24094E 16.87%, #24094E 52.65%, #2C125C 83.75%);

                      return ScaleButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const AchievementScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFFEFEFE).withOpacity(.1),
                            ),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF24094E),
                                Color(0xFF24094E),
                                Color(0xFF2C125C),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Opacity(
                              opacity: index < 5 ? 1 : .2,
                              child: Image.asset(
                                AppImages.badge,
                                width: 46.w,
                                height: 46.w,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _valueCard({
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.1),
          border: const GradientBoxBorder(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFB383),
                Color(0xFFDD96D6),
                Color(0xFF9452FF),
              ],
            ),
          ),
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 32.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFFFEFEFE).withOpacity(.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
