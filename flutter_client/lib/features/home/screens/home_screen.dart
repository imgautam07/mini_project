import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';

import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/chat/screens/chat_screen.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeLeft: true,
          removeRight: true,
          child: SliverAppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            forceElevated: false,
            titleSpacing: 0,
            floating: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: const SizedBox(),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20)) // <-- Radius
                ),
            toolbarHeight: 275.h,
            title: _appBar(),
            // expandedHeight: 250.0,
            // flexibleSpace: FlexibleSpaceBar(
            //   title: Text('Demo'),
            // ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 4,
            (context, index) {
              return Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _profile(40.w),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Priyanshi"),
                            Row(
                              children: [
                                Icon(
                                  IconlyLight.location,
                                  size: 14,
                                  color: Colors.white.withOpacity(.5),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Capetown, Agra, India",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white.withOpacity(.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/app.jpg',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "I'm back with a mobile app exploration. This time, I tried to create a Notes App... more",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(.85),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ScaleButton(
                          scale: 1.2,
                          onTap: () {},
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(IconlyLight.heart)),
                        ),
                        ScaleButton(
                          scale: 1.2,
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              AppImages.comment,
                              width: 24,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            AppImages.more,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Container _appBar() {
    return Container(
      height: 275.h,
      width: 375.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.noiseImage),
          fit: BoxFit.cover,
        ),
        gradient: const LinearGradient(
          transform: GradientRotation(-128),
          colors: [
            Color(0xFF140739),
            Color(0xFF412A81),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 15,
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + 8.h),
          Row(
            children: [
              Consumer<AuthServices>(
                builder: (context, value, _) {
                  String message;

                  int hour = DateTime.now().hour;

                  if (hour >= 5 && hour < 12) {
                    message = 'Good Morning';
                  } else if (hour == 12) {
                    message = 'Good Noon';
                  } else if (hour > 12 && hour < 17) {
                    message = 'Good Afternoon';
                  } else if (hour >= 17 && hour < 20) {
                    message = 'Good Evening';
                  } else {
                    message = 'Good Night';
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "$message, Frank",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const ChatScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Iconsax.message_favorite,
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Suggested for you",
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 100.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) => SizedBox(width: 21.w),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 80.w,
                  child: Column(
                    children: [
                      _profile(80.w),
                      SizedBox(height: 4.h),
                      Flexible(
                        child: Text(
                          "@priyanshii_",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _profile(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFB383),
              Color(0xFFDD96D6),
              Color(0xFF9452FF),
            ],
          ),
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          height: 68.w,
          width: 68.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/post.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
