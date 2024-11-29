import 'package:flutter_client/common/animations/page_transition.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/utils.dart';
import 'package:flutter_client/features/auth/screens/auth/login_screen.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/profile/screens/settings/personal_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          Positioned.fill(
            child: Image.asset(
              AppImages.noiseImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            left: 16.w,
            right: 16.w,
            child: Column(
              children: [
                AppBar(
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      AppImages.back,
                      width: 24.w,
                    ),
                  ),
                  title: const Text("Profile Settings"),
                  centerTitle: true,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _Row(
                          title: "Profile info",
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const PersonalInfoScreen(
                                  exp: "",
                                  prof: [],
                                  tech: [],
                                ),
                              ),
                            );
                          },
                        ),
                        _Row(
                          title: "Notification preferences",
                          onTap: () {},
                        ),
                        _Row(
                          title: "Feedback and support",
                          onTap: () {},
                        ),
                        _Row(
                          title: "About",
                          onTap: () {},
                        ),
                        _Row(
                          title: "Logout",
                          onTap: () async {
                            showLoadingDialog(context);

                            await Provider.of<AuthServices>(context,
                                    listen: false)
                                .logout();

                            if (context.mounted) {
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                CustomPageRoute(const LoginScreen()),
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.onTap,
    this.isDanger = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 26.w,
        ),
        decoration: BoxDecoration(
          color: isDanger
              ? Colors.red.withOpacity(.1)
              : Colors.white.withOpacity(.1),
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(
            color: isDanger
                ? Colors.red.withOpacity(.1)
                : Colors.white.withOpacity(.1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
