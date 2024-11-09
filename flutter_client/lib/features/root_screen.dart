import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/features/discover/screens/discover_screen.dart';
import 'package:flutter_client/features/home/screens/home_screen.dart';
import 'package:flutter_client/features/profile/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/features/projects/screens/project_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.questionBg,
            fit: BoxFit.cover,
          ),
          Image.asset(
            AppImages.noiseImage,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: Container(
              height: 100.h,
              width: 375.w,
              decoration: BoxDecoration(
                color: const Color(0xFF23144F),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32.w),
                ),
                image: DecorationImage(
                  image: AssetImage(AppImages.noiseImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  _navItem(
                    0,
                    image: AppImages.home,
                    selectedImage: AppImages.homeActive,
                    title: "Home",
                  ),
                  _navItem(
                    1,
                    image: AppImages.discover,
                    selectedImage: AppImages.discoverActive,
                    title: "Discover",
                  ),
                  _navItem(
                    2,
                    image: AppImages.library,
                    selectedImage: AppImages.libraryActive,
                    title: "Projects",
                  ),
                  _navItem(
                    3,
                    image: AppImages.profile,
                    selectedImage: AppImages.profileActive,
                    title: "Profile",
                  ),
                ],
              ),
            ),
            body: [
              const HomeScreen(),
              const DiscoverScreen(),
              const ProjectScreen(),
              const ProfileScreen(),
            ][_selected],
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    int index, {
    required String title,
    required String image,
    required String selectedImage,
  }) {
    return Expanded(
      child: CupertinoButton(
        onPressed: () {
          setState(() {
            _selected = index;
          });
        },
        padding: EdgeInsets.zero,
        minSize: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              _selected == index ? selectedImage : image,
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(height: 4.h),
            GradientText(
              title,
              style: TextStyle(fontSize: 13.sp),
              colors: _selected == index
                  ? [
                      const Color(0xFFFFB383),
                      const Color(0xFFDD96D6),
                      const Color(0xFF9452FF),
                    ]
                  : const [
                      Color(0xFF9F7EFF),
                      Color(0xFF9F7EFF),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}
