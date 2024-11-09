import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreIconButton extends StatefulWidget {
  const PreIconButton({
    super.key,
    required this.text,
    required this.image,
    required this.onTap,
  });

  final String text;
  final String image;
  final FutureOr<void> Function() onTap;

  @override
  State<PreIconButton> createState() => _PreIconButtonState();
}

class _PreIconButtonState extends State<PreIconButton> {
  bool isLoading = false;
  Future<void> func() async {
    setState(() {
      isLoading = true;
    });

    try {
      await widget.onTap.call();
    } catch (e) {
      //
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onTap: isLoading
          ? null
          : () async {
              func();
            },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.textColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              child: AnimatedOpacity(
                opacity: isLoading ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: AnimatedScale(
                  scale: isLoading ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Image.asset(
              widget.image,
              height: 20.w,
              width: 20.w,
            ),
            SizedBox(width: 10.w),
            Text(
              widget.text, // ffr
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(width: 10.w),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }
}
