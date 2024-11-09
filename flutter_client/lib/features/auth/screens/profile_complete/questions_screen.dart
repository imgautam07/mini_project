// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/widgets/app_drop_down.dart';
import 'package:flutter_client/features/auth/screens/profile_complete/personal_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int page = 0;
  double cPage = 0.0;
  final PageController _pageController = PageController();
  final _Answers _answers = _Answers();
  List<String> selectedTech = [];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      cPage = (_pageController.page ?? 0);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05040C),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: Image.asset(AppImages.questionBg)),
          Positioned(
            top: 0,
            child: Container(
              width: 375.w,
              height: 250.h,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(32)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF412A81),
                    Color(0xFF140739),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF080618),
                    blurRadius: 200,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Image.asset(
                AppImages.bgTop,
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 120.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF080618).withOpacity(.0),
                    const Color(0xFF080618).withOpacity(1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 160.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF080618).withOpacity(0),
                    const Color(0xFF080618),
                  ],
                ),
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
              child: Column(
            children: [
              SizedBox(height: MediaQuery.paddingOf(context).top + 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: page == 0
                          ? null
                          : () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.fastEaseInToSlowEaseOut,
                              );
                              page--;
                            },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (cPage + 1) / 3,
                        minHeight: 5,
                        color: AppColors.primaryColor,
                        backgroundColor: const Color(0xFF51389A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 120.h,
                          child: _quesText("What’s your\nprofession?"),
                        ),
                        SizedBox(height: 28.h),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _question2('assets/images/q2-1.png', 'Developer'),
                              _question2(
                                  'assets/images/q2-2.png', 'Data Engineer'),
                              _question2('assets/images/q2-3.png', 'Tester'),
                              _question2('assets/images/q2-4.png', 'Designer'),
                              _question2('assets/images/q2-5.png',
                                  'Cybersecurity Analyst'),
                              _question2(
                                  'assets/images/q2-6.png', 'Management'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 120.h,
                              child: _quesText("What’s your\nexperience?"),
                            ),
                            SizedBox(height: 34.h),
                            _question1('assets/images/q1-1.png', 'Fresher', 12),
                            const SizedBox(height: 12),
                            _question1(
                                'assets/images/q1-2.png', 'Under 1 Year', 26),
                            const SizedBox(height: 12),
                            _question1(
                                'assets/images/q1-3.png', 'Under 5 Year', 38),
                            const SizedBox(height: 12),
                            _question1(
                                'assets/images/q1-4.png', '10 Years', 50),
                            const SizedBox(height: 12),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 120.h,
                          width: MediaQuery.sizeOf(context).width,
                          child: _quesText("What's your\nTech Stack"),
                        ),
                        SizedBox(height: 28.h),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Padding(
                                //   padding:
                                //       EdgeInsets.symmetric(horizontal: 16.w),
                                //   child: Row(
                                //     children: [
                                //       _question3(
                                //           'assets/images/q3-1.png', 'Morning'),
                                //       SizedBox(width: 8.w),
                                //       _question3('assets/images/q3-2.png',
                                //           'Afternoon'),
                                //       SizedBox(width: 8.w),
                                //       _question3(
                                //           'assets/images/q3-3.png', 'Evening'),
                                //     ],
                                //   ),
                                // ),
                                // SizedBox(height: 16.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Text(
                                    "What is your Tech Stack",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.5),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: AppDropDown(
                                    entries: AuthServices()
                                        .techOptions
                                        .map(
                                          (e) => AppDropDownEntry(
                                            label: e,
                                            value: e,
                                          ),
                                        )
                                        .toList(),
                                    selected: selectedTech,
                                    onEntrySelected: (value) {
                                      if (selectedTech.contains(value.value)) {
                                        selectedTech.remove(value.value);
                                      } else {
                                        selectedTech.add(value.value);
                                      }
                                      setState(() {});
                                      String val =
                                          _answers.startAt.split('-')[1];
                                      _answers.startAt = _answers.startAt
                                          .replaceAll(val, value.value);

                                      setState(() {});
                                    },
                                    hintText: "Select technologies",
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 10.h,
                                  ),
                                  child: Wrap(
                                    children: selectedTech
                                        .map(
                                          (e) => Container(
                                            margin: const EdgeInsets.only(
                                                right: 10, bottom: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF9452FF)
                                                  .withOpacity(.3),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Spacer(),
                  ScaleButton(
                    onTap: ((page == 0 && _answers.intentions.isEmpty) ||
                            (page == 1 && _answers.experience == '') ||
                            (selectedTech.isEmpty))
                        ? null
                        : () {
                            if (cPage <= 1.5) {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastEaseInToSlowEaseOut);
                              page++;
                            } else {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => PersonalDetails(
                                    data: _answers.toMap(),
                                  ),
                                ),
                              );
                            }
                          },
                    child: Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFEFEFE).withOpacity(.1),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                ],
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 12.h),
            ],
          )),
        ],
      ),
    );
  }

  Widget _question3(String image, String text) {
    String value = _answers.startAt.split('-')[0];

    return ScaleButton(
      onTap: value == text
          ? null
          : () {
              _answers.startAt = _answers.startAt.replaceAll(value, text);
              setState(() {});
            },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        width: 109.w,
        height: 92.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(.1),
          border: value == text
              ? const GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFB383),
                      Color(0xFFDD96D6),
                      Color(0xFF9452FF),
                    ],
                  ),
                )
              : Border.all(
                  color: Colors.white.withOpacity(.1),
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              width: 32.h,
              height: 32.h,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ScaleButton _question1(
    String image,
    String text,
    double imgSize,
  ) {
    return ScaleButton(
      onTap: () {
        page++;
        _answers.experience = text;
        _pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastEaseInToSlowEaseOut);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFFEFEFE).withOpacity(.1),
          border: _answers.experience == text
              ? const GradientBoxBorder(
                  gradient: LinearGradient(colors: [
                    Color(0xFFFFB383),
                    Color(0xFFDD96D6),
                    Color(0xFF9452FF)
                  ]),
                )
              : Border.all(
                  color: const Color(0xFFFEFEFE).withOpacity(.1),
                  width: 1,
                ),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: Image.asset(
                  image,
                  height: imgSize,
                  width: imgSize,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ScaleButton _question2(
    String image,
    String text,
  ) {
    return ScaleButton(
      onTap: () {
        if (_answers.intentions.contains(text)) {
          _answers.intentions.remove(text);
        } else {
          _answers.intentions.add(text);
        }
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFFEFEFE).withOpacity(.1),
          border: _answers.intentions.contains(text)
              ? const GradientBoxBorder(
                  gradient: LinearGradient(colors: [
                    Color(0xFFFFB383),
                    Color(0xFFDD96D6),
                    Color(0xFF9452FF)
                  ]),
                  width: 1,
                )
              : Border.all(
                  color: const Color(0xFFFEFEFE).withOpacity(.1),
                  width: 1,
                ),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Center(
                child: Image.asset(image),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                border: _answers.intentions.contains(text)
                    ? null
                    : Border.all(color: Colors.white.withOpacity(.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _answers.intentions.contains(text)
                  ? const Center(child: Icon(IconlyBold.tickSquare))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _quesText(String text) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _Answers {
  String experience = "";
  List<String> intentions = [];
  String startAt = "title-time";

  Map<String, dynamic> toMap() => {
        'experience': experience,
        'intentions': intentions,
        'startAt': startAt.split('-')[0],
        'remindAt': startAt.split('-')[1],
      };
}
