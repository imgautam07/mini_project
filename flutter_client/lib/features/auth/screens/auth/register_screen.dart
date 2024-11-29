import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/app_%20button.dart';
import 'package:flutter_client/common/buttons/pre_icon_button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/widgets/custom_textfield.dart';
import 'package:flutter_client/features/auth/screens/profile_complete/questions_screen.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/root_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _mail = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _fKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _mail.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.bgImage,
              fit: BoxFit.cover,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            top: (((100.h + MediaQuery.paddingOf(context).top) -
                        (MediaQuery.viewInsetsOf(context).bottom * 0.5)) <
                    0
                ? 0
                : ((100.h + MediaQuery.paddingOf(context).top) -
                    (MediaQuery.viewInsetsOf(context).bottom * 0.5))),
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF000000).withOpacity(.25),
                      blurRadius: 15,
                      offset: const Offset(0, 8)),
                ],
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF412A81),
                    Color(0xFF140739),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      AppImages.cardBg,
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
          AnimatedPositioned(
            left: 0,
            right: 0,
            top: -(MediaQuery.viewInsetsOf(context).bottom * 0.5),
            duration: const Duration(milliseconds: 100),
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top + 22.h,
              ),
              child: Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            left: 16.w,
            right: 16.w,
            bottom: 0,
            top: ((((100.h) - (MediaQuery.viewInsetsOf(context).bottom * 0.5)) <
                        0
                    ? 0
                    : ((100.h) -
                        (MediaQuery.viewInsetsOf(context).bottom * 0.5)))) +
                MediaQuery.paddingOf(context).top +
                16.w,
            child: Form(
              key: _fKey,
              child: SingleChildScrollView(
                child: Consumer<AuthServices>(
                  builder: (context, value, _) {
                    return Column(
                      children: [
                        CustomTextField(
                          hintText: "Type Email",
                          title: "Email address",
                          controller: _mail,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter your mail address";
                            }
                            if (!isEmail(value)) {
                              return "Invalid mail address";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          hintText: "Type Password",
                          title: "Password",
                          controller: _password,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter your password";
                            }
                            if (value.length < 6) {
                              return "Must have at least 6 chars";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          hintText: "Repeat Password",
                          title: "Repeat Password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm password";
                            }
                            if (_password.text != value) {
                              return "Password didn't matched";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40.h),
                        AppButton.fromText(
                          text: "Sign Up",
                          onTap: () async {
                            if (_fKey.currentState?.validate() ?? false) {
                              var res = await Provider.of<AuthServices>(context,
                                      listen: false)
                                  .signup(
                                email: _mail.text,
                                password: _password.text,
                              );

                              if (res && context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => const QuestionsScreen(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Failed to create account!!",
                                );
                              }
                            }
                          },
                        ),
                        SizedBox(height: 160.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Have an account?",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 0,
                              child: Text(
                                " Sign In",
                                style: TextStyle(
                                  color: const Color(0xFFFFB383),
                                  fontSize: 16.sp,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                            height:
                                MediaQuery.paddingOf(context).bottom + 16.h),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
