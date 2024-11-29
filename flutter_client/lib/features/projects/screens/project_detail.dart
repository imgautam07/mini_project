import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_client/common/buttons/app_%20button.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/models/user_info_model.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/home/provider/post_provider.dart';
import 'package:flutter_client/features/projects/models/project_model.dart';
import 'package:flutter_client/features/projects/screens/project_chat.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({super.key, required this.model});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();

  final ProjectModel model;
}

class _ProjectDetailState extends State<ProjectDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 20.h,
          left: 20.w,
          right: 20.w,
        ),
        child: SizedBox(
          height: 64,
          child: AppButton.fromText(
            text: "Trace",
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => ProjectChatting(model: widget.model),
                ),
              );
            },
            icon: Icons.arrow_forward,
          ),
        ),
      ),
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
                children: [
                  SizedBox(height: MediaQuery.paddingOf(context).top + 20.h),
                  MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: AppBar(
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Iconsax.arrow_left,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(widget.model.title),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40.h),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/project.png',
                              ),
                            ),
                          ),
                          const SizedBox(height: 29),
                          Text(
                            widget.model.description,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Icon(
                                Iconsax.box,
                                size: 26,
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                widget.model.title,
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
                                Iconsax.calendar,
                                size: 26,
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                "${DateFormat('dd MMM').format(widget.model.startDate)} to ${DateFormat('dd MMM yyyy').format(widget.model.startDate)}",
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
                                Iconsax.profile_2user,
                                size: 26,
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                "Team Members",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: widget.model.userIds.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                future: Provider.of<PostProvider>(context,
                                        listen: false)
                                    .getUserById(widget.model.userIds[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return const SizedBox.shrink();
                                  }

                                  UserInfoModel user = snapshot.data!;

                                  return ScaleButton(
                                    onTap: () {
                                      _profileModal(user);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            AppImages.profile,
                                            width: 35,
                                            height: 35,
                                          ),
                                          SizedBox(width: 10.w),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.name,
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(user.experience),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.paddingOf(context).bottom + 140.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _profileModal(UserInfoModel model) {
    return showCupertinoModalPopup(
      barrierColor: const Color(0xCC0A0826),
      context: context,
      builder: (context) {
        return _ProfileDailog(model: model);
      },
    );
  }
}

class _ProfileDailog extends StatelessWidget {
  const _ProfileDailog({
    required this.model,
  });

  final UserInfoModel model;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              gradient: const LinearGradient(
                transform: GradientRotation(-360 + 128),
                colors: [
                  Color(0xFF412A81),
                  Color(0xFF140739),
                ],
              ),
              image: DecorationImage(
                image: AssetImage(AppImages.noiseImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  model.name,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(
                      IconlyLight.work,
                      size: 12,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Profession",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  children: model.professions
                      .map(
                        (e) => Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(e),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(
                      IconlyLight.paper,
                      size: 12,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Skills",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  children: model.technologies
                      .map(
                        (e) => Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(e),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 30),
                AppButton.fromText(
                  text: "Add Friend",
                  icon: IconlyLight.addUser,
                  onTap: () async {
                    var res =
                        await Provider.of<AuthServices>(context, listen: false)
                            .addFriend(model.id);

                    if (res && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(height: 20 + MediaQuery.paddingOf(context).bottom),
              ],
            ),
          ),
        ),
      );
    });
  }
}
