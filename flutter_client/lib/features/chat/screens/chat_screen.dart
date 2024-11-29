import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/widgets/app_bar.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/chat/screens/chatting_page.dart';
import 'package:flutter_client/features/home/provider/post_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            child: CustomScrollView(
              slivers: [
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  removeLeft: true,
                  removeRight: true,
                  child: SliverAppBar(
                    scrolledUnderElevation: 0,
                    floating: true,
                    leading: const SizedBox.shrink(),
                    leadingWidth: 0,
                    titleSpacing: 0,
                    backgroundColor: Colors.transparent,
                    toolbarHeight: 205.h,
                    title: AtonAppBar(
                      title: "Messaging",
                      defaultSelectedOption: "All",
                      bottomOptions: [
                        AppBarOption(title: "All"),
                        AppBarOption(title: "Projects"),
                        AppBarOption(title: "Unread"),
                        AppBarOption(title: "+"),
                      ],
                      onSelect: (value) {
                        setState(() {
                          _selected = value;
                        });
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: 10.h,
                    left: 12.w,
                    right: 12.w,
                  ),
                  sliver: Consumer<AuthServices>(builder: (context, value, _) {
                    return SliverList.separated(
                      itemCount: value.userInfoModel?.friends.length ?? 0,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 28.h),
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                            future: Provider.of<PostProvider>(context,
                                    listen: false)
                                .getUserById(
                                    value.userInfoModel!.friends[index]),
                            builder: (context, snapshot) {
                              return CupertinoButton(
                                onPressed: snapshot.data == null
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (_) => ChattingPage(
                                              model: snapshot.data!,
                                            ),
                                          ),
                                        );
                                      },
                                padding: EdgeInsets.zero,
                                child: Container(
                                  padding: EdgeInsets.all(0.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.asset(
                                          AppImages.profile,
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${snapshot.data?.name ?? 0}",
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const Spacer(),
                                                if (index < 3)
                                                  Icon(
                                                    Icons.circle,
                                                    size: 10,
                                                    color: Colors.white
                                                        .withOpacity(.3),
                                                  ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${snapshot.data?.experience ?? 0}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
