import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/app_%20button.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/widgets/app_drop_down.dart';
import 'package:flutter_client/common/widgets/custom_textfield.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/home/provider/post_provider.dart';
import 'package:flutter_client/features/projects/provider/project_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final TextEditingController _title = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final TextEditingController _content = TextEditingController();
  final ValueNotifier<List<String>> _users = ValueNotifier<List<String>>([]);
  List<String> userNames = [];

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
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 2,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: _title,
                      title: "Project Title",
                      hintText: "Enter post title",
                    ),
                    SizedBox(height: 12.h),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Project Mates",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textColor.withOpacity(.5),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Consumer<AuthServices>(builder: (context, value, _) {
                      return FutureBuilder(
                          future:
                              Provider.of<PostProvider>(context, listen: false)
                                  .getUsersByIds(
                                      value.userInfoModel?.friends ?? []),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return const SizedBox();
                            }
                            return ValueListenableBuilder(
                                valueListenable: _users,
                                builder: (context, users, _) {
                                  return AppDropDown(
                                    entries: snapshot.data!
                                        .map(
                                          (e) => AppDropDownEntry(
                                            label: e.name,
                                            value: e.id,
                                          ),
                                        )
                                        .toList(),
                                    selected: users,
                                    onEntrySelected: (value) {
                                      if (users.contains(value.value)) {
                                        var r = List<String>.from(users);
                                        r.remove(value.value);

                                        _users.value = r;
                                        userNames.remove(value.label);
                                      } else {
                                        var r = List<String>.from(users);
                                        r.add(value.value);
                                        _users.value = r;
                                        userNames.add(value.label);
                                      }
                                      setState(() {});
                                    },
                                    hintText: "Select Project Mates",
                                  );
                                });
                          });
                    }),
                    SizedBox(height: 8.h),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: ValueListenableBuilder(
                        valueListenable: _users,
                        builder: (context, value, child) {
                          return Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            children: userNames.map((e) => _chip(e)).toList(),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: _content,
                      title: "Project Descripton",
                      hintText: "Enter project descripton",
                      maxLines: 10,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Start Date",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textColor.withOpacity(.5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (value) {
                          startDate = value;
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "End Date",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textColor.withOpacity(.5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (value) {
                          endDate = value;
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 45.h),
                    AppButton.fromText(
                      text: "Create Prject",
                      onTap: () async {
                        var r = await Provider.of<ProjectProvider>(context,
                                listen: false)
                            .addProject(
                          title: _title.text,
                          description: _content.text,
                          users: _users.value,
                          endDate: endDate,
                          startDate: startDate,
                        );

                        if (r && context.mounted) {
                          Navigator.pop(context);
                          return;
                        }

                        Fluttertoast.showToast(
                            msg: "Failed to create projectmai");
                      },
                      icon: Iconsax.send_2,
                    ),
                    SizedBox(
                        height: MediaQuery.paddingOf(context).bottom + 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String message) {
    return ScaleButton(
      onTap: () {
        List<String> i = _users.value;
        i.remove(message);
        _users.value = List.from(i);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(.4),
          borderRadius: BorderRadius.circular(120),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 12),
            Text(message),
            const SizedBox(width: 12),
            Icon(
              Iconsax.close_circle,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.7),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
