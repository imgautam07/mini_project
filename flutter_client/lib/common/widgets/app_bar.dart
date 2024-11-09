import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class AtonAppBar extends StatefulWidget {
  const AtonAppBar({
    super.key,
    required this.bottomOptions,
    required this.onSelect,
    this.defaultSelectedOption,
    required this.title,
  });

  @override
  State<AtonAppBar> createState() => _AtonAppBarState();

  final List<AppBarOption> bottomOptions;
  final void Function(String value) onSelect;
  final String? defaultSelectedOption;
  final String title;
}

class _AtonAppBarState extends State<AtonAppBar> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.defaultSelectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205.h,
      width: 375.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.noiseImage),
          fit: BoxFit.cover,
        ),
        gradient: const LinearGradient(
          transform: GradientRotation(-360 + 128),
          colors: [
            Color(0xFF412A81),
            Color(0xFF140739),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                if (Navigator.canPop(context))
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      AppImages.back,
                      width: 22.w,
                    ),
                  ),
                if (Navigator.canPop(context)) const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(height: 12.h),
          SizedBox(
            height: 40.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              scrollDirection: Axis.horizontal,
              itemCount: widget.bottomOptions.length,
              separatorBuilder: (context, index) => SizedBox(width: 6.w),
              itemBuilder: (context, index) {
                AppBarOption item = widget.bottomOptions[index];
                String title = item.title;
                return ScaleButton(
                  onTap: _selected == item.title
                      ? null
                      : () {
                          setState(() {
                            _selected = title;
                          });
                          item.onTap?.call();
                        },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: item.image == null ? 24.w : 14.w,
                      right: 24.w,
                      top: 8.h,
                      bottom: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.1),
                      borderRadius: BorderRadius.circular(122),
                      border: _selected == title
                          ? const GradientBoxBorder(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFFB383),
                                  Color(0xFFDD96D6),
                                  Color(0xFF9452FF),
                                ],
                              ),
                              width: 1.5,
                            )
                          : Border.all(
                              color: Colors.white.withOpacity(.1),
                              width: 1.5,
                            ),
                    ),
                    child: Row(
                      children: [
                        if (item.image != null)
                          Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Image.asset(
                              item.image!,
                              color: _selected == title
                                  ? Colors.white
                                  : const Color(0xFFFEFEFE).withOpacity(.5),
                            ),
                          ),
                        FittedBox(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _selected == title
                                  ? Colors.white
                                  : const Color(0xFFFEFEFE).withOpacity(.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

class AppBarOption {
  String title;
  String? image;
  VoidCallback? onTap;

  AppBarOption({
    required this.title,
    this.onTap,
    this.image,
  });
}
