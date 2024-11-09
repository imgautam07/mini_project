import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/app_%20button.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

Future<dynamic> showErrorDialog(BuildContext context, String message) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * .5,
              width: MediaQuery.sizeOf(context).width * .8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: AppColors.bgColor,
                      ),
                    ),
                    Positioned.fill(
                      child: Image.asset(
                        AppImages.bgTop,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Image.asset(
                        AppImages.cardBg,
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
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            Icon(
                              IconlyBroken.infoCircle,
                              color: Theme.of(context).colorScheme.error,
                              size: 64.w,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Error",
                              style: TextStyle(
                                fontSize: 24.sp,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Expanded(
                              child: Text(
                                message,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            FractionallySizedBox(
                              widthFactor: .8,
                              child: AppButton(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Text(
                                  "Ok",
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<ImageSource?> sourceSelect(BuildContext context) async {
  ImageSource? source;

  await showCupertinoDialog(
    context: context,
    builder: (context) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).width * .7,
              width: MediaQuery.sizeOf(context).width * .8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: AppColors.bgColor,
                      ),
                    ),
                    Positioned.fill(
                      child: Image.asset(
                        AppImages.bgTop,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Image.asset(
                        AppImages.cardBg,
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
                      top: 20,
                      left: 40,
                      right: 40,
                      bottom: 20,
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "Choose",
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: CupertinoButton(
                                    onPressed: () {
                                      source = ImageSource.camera;
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/camera.png',
                                          width: 40.w,
                                          height: 40.w,
                                        ),
                                        SizedBox(height: 8.h),
                                        const Text(
                                          "Camera",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: CupertinoButton(
                                    onPressed: () {
                                      source = ImageSource.gallery;
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/gallery.png',
                                          width: 35.w,
                                          height: 35.w,
                                        ),
                                        SizedBox(height: 8.h),
                                        const Text(
                                          "Gallery",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CupertinoButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "cancel",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  return source;
}

SizedBox emptyState(String message) {
  return SizedBox(
    width: 274.w,
    height: 210.h,
    child: Column(
      children: [
        SizedBox(
          height: 123.w,
          width: 123.w,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      height: 123.w,
                      width: 123.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.05),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      height: 78.w,
                      width: 78.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.05),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  AppImages.folderOpen,
                  width: 32.w,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 38.h),
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
                color: Colors.white.withOpacity(.8),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

showLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    barrierColor: const Color(0xCC0A0826),
    context: context,
    builder: (_) => ScaleButton(
      onTap: () {
        Navigator.pop(context);
      },
      child: const CupertinoActivityIndicator(
        radius: 20,
        color: Colors.white,
      ),
    ),
  );
}
