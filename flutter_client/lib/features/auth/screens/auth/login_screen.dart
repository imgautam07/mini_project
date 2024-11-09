import 'package:flutter_client/common/animations/page_transition.dart';
import 'package:flutter_client/common/buttons/app_%20button.dart';
import 'package:flutter_client/common/buttons/pre_icon_button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/constants/app_strings.dart';
import 'package:flutter_client/common/utils.dart';
import 'package:flutter_client/common/widgets/custom_textfield.dart';
import 'package:flutter_client/features/auth/screens/auth/register_screen.dart';
import 'package:flutter_client/features/auth/screens/profile_complete/questions_screen.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/home/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/features/root_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                        MediaQuery.viewInsetsOf(context).bottom * .5) <
                    0
                ? 0
                : ((100.h + MediaQuery.paddingOf(context).top) -
                    MediaQuery.viewInsetsOf(context).bottom * .5)),
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
            duration: const Duration(milliseconds: 100),
            left: 0,
            right: 0,
            top: -MediaQuery.viewInsetsOf(context).bottom * 0.5,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top + 22.h,
              ),
              child: Center(
                child: Text(
                  "Sign In",
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
            top: (((100.h - MediaQuery.viewInsetsOf(context).bottom * .5) < 0
                    ? 0
                    : ((100.h) -
                        MediaQuery.viewInsetsOf(context).bottom * .5))) +
                MediaQuery.paddingOf(context).top +
                16.w,
            child: Form(
              key: _fKey,
              child: SingleChildScrollView(
                child: Consumer<AuthServices>(builder: (context, value, _) {
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
                      CupertinoButton(
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.textColor,
                          ),
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(height: 30.h),
                      AppButton.fromText(
                        text: "Sign In",
                        onTap: () async {
                          if (_fKey.currentState?.validate() ?? false) {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => const RootScreen()),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 160.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CustomPageRoute(const RegisterScreen()),
                              );
                            },
                            child: Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CustomPageRoute(const RegisterScreen()),
                              );
                            },
                            padding: EdgeInsets.zero,
                            minSize: 0,
                            child: Text(
                              " Sign Up",
                              style: TextStyle(
                                color: const Color(0xFFFFB383),
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.paddingOf(context).bottom + 16.h),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
