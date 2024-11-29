import 'package:flutter/cupertino.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/features/projects/models/project_model.dart';
import 'package:flutter_client/features/projects/provider/project_provider.dart';
import 'package:flutter_client/features/projects/screens/project_detail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  String _selected = "All";

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
            titleSpacing: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: 205.h,
            title: AtonAppBar(
              title: "Projects",
              defaultSelectedOption: "All",
              bottomOptions: [
                AppBarOption(title: "All"),
                AppBarOption(title: "Pending"),
                AppBarOption(title: "Completed"),
              ],
              onSelect: (value) {
                setState(() {
                  _selected = value;
                });
              },
            ),
          ),
        ),
        Consumer<ProjectProvider>(builder: (context, value, _) {
          return SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: SliverList.separated(
              itemCount: value.projects.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                ProjectModel model = value.projects[index];

                return ScaleButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ProjectDetail(model: model),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(.9),
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/project.png',
                              width: 100,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Members :",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.4),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    " ${model.userIds.length}",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.4),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            AppImages.more,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
