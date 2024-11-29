import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/features/auth/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingNextScreen extends StatefulWidget {
  const OnboardingNextScreen({super.key});

  @override
  State<OnboardingNextScreen> createState() => _OnboardingNextScreenState();
}

class _OnboardingNextScreenState extends State<OnboardingNextScreen> {
  int page = 0;
  double cPage = 0;

  String onb1 = AppImages.onb1Image;
  String onb2 = AppImages.onb2Image;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      cPage = _pageController.page ?? 0;
      setState(() {});
    });
  }

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
          Positioned(
            bottom: 0,
            child: AnimatedCrossFade(
              firstChild: Image.asset(
                onb1,
                width: 375.w,
                height: 616.h,
              ),
              secondChild: Image.asset(
                onb2,
                width: 375.w,
                height: 616.h,
              ),
              crossFadeState: (page == 0 || page == 2)
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 400),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 375.w,
              height: 308.h,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(32)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF412A81),
                    Color(0xFF140739),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF080618),
                    blurRadius: 200,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 160.h,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(32)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF080618).withOpacity(0),
                            const Color(0xFF080618),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Image.asset(
                      AppImages.bgTop,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              AppImages.noiseImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 160.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF080618).withOpacity(0),
                    const Color(0xFF080618),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.paddingOf(context).top + 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (page == 0) {
                            Navigator.pop(context);
                          } else {
                            if (page == 1) {
                              onb1 = AppImages.onb1Image;
                              setState(() {});
                            }
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.fastEaseInToSlowEaseOut,
                            );
                            page--;
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (cPage + 1) / 3,
                          minHeight: 5,
                          color: AppColors.primaryColor,
                          backgroundColor: const Color(0xFF51389A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 375.h,
                  width: double.infinity,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      _onbText(
                        'Build Your Community, Share Your Story',
                        'Express yourself, connect with like-minded people, and showcase your work. Engage with content, manage projects, and stay updated with notifications.',
                      ),
                      _onbText(
                        'Hub for Networking and Growth',
                        'Connect, create, and collaborate in your space to bring ideas to life. Explore a dynamic feed, manage projects, and keep conversations organized.',
                      ),
                      _onbText(
                        'Where Connections Drive Your Success',
                        'Discover a platform beyond networking—manage projects, collaborate in real-time, and join engaging discussions in a community built for creators.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            right: 16.w,
            child: ScaleButton(
              onTap: () {
                if (cPage <= 1.5) {
                  if (cPage == 1) {
                    onb1 = AppImages.onb3Image;
                    setState(() {});
                  }

                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastEaseInToSlowEaseOut);
                  page++;
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textColor,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 24.w,
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: MediaQuery.paddingOf(context).bottom + 16,
          //   right: 16.w,
          //   child: GestureDetector(
          //     onTap: () {
          //       // if (page <= 2) {
          //       _pageController.nextPage(
          //         duration: const Duration(microseconds: 400),
          //         curve: Curves.fastEaseInToSlowEaseOut,
          //       );
          //       // if (page == 2) {
          //       //   onb1 = AppImages.onb3Image;
          //       // }
          //       // setState(() {
          //       //   page++;
          //       // });
          //       // } else {
          //       //   showCupertinoDialog(
          //       //     context: context,
          //       //     builder: (context) => const CupertinoAlertDialog(),
          //       //   );

          //       //   Navigator.push(context,
          //       //       CupertinoPageRoute(builder: (_) => const LoginScreen()));
          //       // }
          //     },
          //     child: Container(
          //       padding: EdgeInsets.all(18.w),
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: AppColors.textColor,
          //       ),
          //       child: Icon(
          //         Icons.arrow_forward,
          //         color: Colors.black,
          //         size: 24.w,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _onbText(
    String title,
    String subTitle,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.sp,
              letterSpacing: -1,
              color: AppColors.textColor,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textColor.withOpacity(.5),
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
