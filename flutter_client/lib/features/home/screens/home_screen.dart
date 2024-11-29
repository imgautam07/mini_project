import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/app_%20button.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';

import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/models/user_info_model.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/chat/screens/chat_screen.dart';
import 'package:flutter_client/features/home/models/post_model.dart';
import 'package:flutter_client/features/home/provider/post_provider.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeLeft: true,
          removeRight: true,
          child: SliverAppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            forceElevated: false,
            titleSpacing: 0,
            floating: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: const SizedBox(),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20)) // <-- Radius
                ),
            toolbarHeight: 135.h,
            title: _appBar(),
            // expandedHeight: 250.0,
            // flexibleSpace: FlexibleSpaceBar(
            //   title: Text('Demo'),
            // ),
          ),
        ),
        Consumer<PostProvider>(builder: (context, value, _) {
          return SliverList.separated(
            itemCount: value.posts.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return _postCard(value.posts[index]);
            },
          );
        }),
      ],
    );
  }

  Widget _postCard(PostModel model) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FutureBuilder(
                  future: Provider.of<PostProvider>(context, listen: false)
                      .getUserById(model.userId),
                  builder: (context, snapshot) {
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: snapshot.data == null
                          ? null
                          : () {
                              _profileModal(snapshot.data!);
                            },
                      child: Container(
                        color: Colors.white.withOpacity(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data?.name ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  IconlyLight.work,
                                  size: 14,
                                  color: Colors.white.withOpacity(.5),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  snapshot.data?.professions.first ?? "",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white.withOpacity(.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            model.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
          Text(model.content),
          const SizedBox(height: 10),
          Wrap(
            children: model.tags
                .map(
                  (e) => Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text("#${e.toLowerCase()}"),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ScaleButton(
                scale: 1.2,
                onTap: () {},
                child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(IconlyLight.heart)),
              ),
              ScaleButton(
                scale: 1.2,
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    AppImages.comment,
                    width: 24,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  log(model.id);
                  var res =
                      await Provider.of<PostProvider>(context, listen: false)
                          .deletePost("post:${model.id}");
                  log(" $res");
                },
                icon: Image.asset(
                  AppImages.more,
                  width: 24,
                ),
              ),
            ],
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

  Container _appBar() {
    return Container(
      height: 130.h,
      width: 375.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.noiseImage),
          fit: BoxFit.cover,
        ),
        gradient: const LinearGradient(
          transform: GradientRotation(-128),
          colors: [
            Color(0xFF140739),
            Color(0xFF412A81),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 15,
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + 8.h),
          Row(
            children: [
              Consumer<AuthServices>(
                builder: (context, value, _) {
                  String message;

                  int hour = DateTime.now().hour;

                  if (hour >= 5 && hour < 12) {
                    message = 'Morning';
                  } else if (hour == 12) {
                    message = 'Noon';
                  } else if (hour > 12 && hour < 17) {
                    message = 'Afternoon';
                  } else if (hour >= 17 && hour < 20) {
                    message = 'Evening';
                  } else {
                    message = 'Night';
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Consumer<AuthServices>(builder: (context, value, _) {
                      return Text(
                        "$message, ${value.userInfoModel?.name ?? "-"}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                  );
                },
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const ChatScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Iconsax.message_favorite,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _profile(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFB383),
              Color(0xFFDD96D6),
              Color(0xFF9452FF),
            ],
          ),
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          height: 68.w,
          width: 68.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/post.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
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

                    log("$res");

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
