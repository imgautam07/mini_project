// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_client/common/widgets/custom_textfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/widgets/app_bar.dart';
import 'package:iconsax/iconsax.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  List<Chat> chatMessages = [
    Chat(message: "Hey! How's it going?", isYou: true),
    Chat(message: "Hi! All good here, thanks. How about you?", isYou: false),
    Chat(message: "I'm doing well, just working on a project.", isYou: true),
    Chat(message: "I'm doing well, just working on a project.", isYou: true),
    Chat(message: "Sounds interesting! What kind of project?", isYou: false),
    Chat(message: "It's a mobile app for booking vehicles.", isYou: true),
    Chat(message: "It's a mobile app for booking vehicles.", isYou: true),
    Chat(message: "That sounds cool! Need any help?", isYou: false),
    Chat(message: "Actually, that would be awesome! Thanks!", isYou: true),
  ];

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
            child: Column(
              children: [
                Container(
                  width: 375.w,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                      SizedBox(
                          height: MediaQuery.paddingOf(context).top + 10.h),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Image.asset(
                              AppImages.back,
                              width: 24,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white.withOpacity(.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    'assets/images/post.png',
                                    fit: BoxFit.cover,
                                    width: 40.w,
                                    height: 40.w,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Excleta Wick",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Text(
                                      "Online",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: chatMessages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          if (chatMessages[index].isYou) const Spacer(),
                          SizedBox(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 6.h),
                              constraints: BoxConstraints(
                                minWidth: 0,
                                maxWidth: MediaQuery.sizeOf(context).width * .6,
                              ),
                              decoration: BoxDecoration(
                                color: chatMessages[index].isYou
                                    ? null
                                    : const Color(0xFF140739),
                                borderRadius: BorderRadius.circular(12),
                                gradient: !chatMessages[index].isYou
                                    ? null
                                    : LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFF412A81),
                                          const Color(0xFF412A81)
                                              .withOpacity(.8),
                                          // Color(0xFF140739),
                                        ],
                                      ),
                              ),
                              child: Text(chatMessages[index].message),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 12.h,
                left: 8,
                right: 8,
                top: 8,
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 49, 31, 98),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Send message ...",
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.send_1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Chat {
  String message;
  bool isYou;
  Chat({
    required this.message,
    required this.isYou,
  });
}
