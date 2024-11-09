import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.title,
    required this.hintText,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines,
    this.unfocus = true,
    this.autofocus = false,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String title;
  final String hintText;
  final String? Function(String? value)? validator;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final bool unfocus;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final GlobalKey<FormFieldState> _globalKey = GlobalKey<FormFieldState>();
  final FocusNode _node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _node.requestFocus();
          },
          child: Column(
            children: [
              Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textColor.withOpacity(.5),
                ),
              ),
              SizedBox(height: 6.h),
            ],
          ),
        ),
        TextFormField(
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          key: _globalKey,
          focusNode: _node,
          validator: (value) {
            if (widget.validator != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
            }
            return widget.validator?.call(value);
          },
          controller: widget.controller,
          onTapOutside: (_) {
            if (widget.unfocus) FocusManager.instance.primaryFocus?.unfocus();
          },
          decoration: InputDecoration(
            fillColor: _globalKey.currentState?.errorText == null
                ? AppColors.textColor.withOpacity(.1)
                : Theme.of(context).colorScheme.error.withOpacity(.1),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.w),
            filled: true,
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.textColor.withOpacity(.1),
                width: 1.w,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.textColor.withOpacity(.1),
                width: 1.w,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error.withOpacity(.5),
                width: 1.w,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.primaryColor.withOpacity(.2),
                width: 2.w,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
