import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/app_%20button.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({super.key});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: RotatedBox(
              quarterTurns: 1,
              child: Image.asset(
                AppImages.promoBg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              AppImages.noiseImage,
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
            left: 20.w,
            right: 20.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.paddingOf(context).top + 20.h),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Iconsax.arrow_left,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 60.h),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/project.png',
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.box,
                        size: 26,
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "Food Delivery Project",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.card,
                        size: 26,
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "Flutter Your Way",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.calendar,
                        size: 26,
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "12 May to 18 Nov 2024",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AppButton.fromText(
                    text: "Trace",
                    onTap: () {},
                    icon: Icons.arrow_forward,
                  ),
                  SizedBox(height: MediaQuery.paddingOf(context).bottom + 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
