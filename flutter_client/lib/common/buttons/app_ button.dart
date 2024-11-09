import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatefulWidget {
  const AppButton(
      {super.key, required this.child, required this.onTap, this.padding});

  @override
  State<AppButton> createState() => AppButtonState();

  final Widget child;
  final FutureOr<void> Function() onTap;
  final EdgeInsets? padding;

  static fromText({
    required String text,
    required FutureOr<void> Function() onTap,
    IconData? icon,
    EdgeInsets? padding,
  }) {
    return AppButton(
      padding: padding,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          if (icon != null) SizedBox(width: 10.w),
          if (icon != null) Icon(icon, color: AppColors.textColor),
        ],
      ),
    );
  }
}

class AppButtonState extends State<AppButton> {
  bool isLoading = false;

  func() async {
    setState(() {
      isLoading = true;
    });

    try {
      await widget.onTap();
    } catch (e) {
      log("$e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onTap: isLoading ? null : func,
      child: Container(
        padding: widget.padding ?? EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFB383).withOpacity(isLoading ? .5 : 1),
              const Color(0xFFDD96D6).withOpacity(isLoading ? .5 : 1),
              const Color(0xFF9452FF).withOpacity(isLoading ? .5 : 1),
            ],
          ),
        ),
        child: Center(
          child: isLoading
              ? const CupertinoActivityIndicator(
                  color: Colors.white,
                )
              : widget.child,
        ),
      ),
    );
  }
}
