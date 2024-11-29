import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/app_%20button.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/widgets/custom_textfield.dart';
import 'package:flutter_client/features/home/provider/post_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final ValueNotifier<List<String>> _interests =
      ValueNotifier<List<String>>([]);
  bool _showSubmit = false;

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
                child: SizedBox(
                  height:
                      MediaQuery.sizeOf(context).height - kToolbarHeight - 60.h,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: _title,
                        title: "Post Title",
                        hintText: "Enter post title",
                      ),
                      SizedBox(height: 12.h),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Tags",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textColor.withOpacity(.5),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      StatefulBuilder(builder: (context, reBuild) {
                        return TextFormField(
                          textInputAction: TextInputAction.go,
                          controller: _interestController,
                          decoration: InputDecoration(
                            hintText: "Enter Tags",
                            fillColor: AppColors.textColor.withOpacity(.1),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 18.w),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.textColor.withOpacity(.1),
                                width: 1.w,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.textColor.withOpacity(.1),
                                width: 1.w,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(.5),
                                width: 1.w,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor.withOpacity(.2),
                                width: 2.w,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                            ),
                            suffixIcon: AnimatedOpacity(
                              opacity: _showSubmit ? 1 : 0,
                              duration: const Duration(milliseconds: 400),
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: !_showSubmit
                                    ? null
                                    : () {
                                        List<String> i = _interests.value;
                                        if (!i.contains(
                                            _interestController.text)) {
                                          i.add(_interestController.text);
                                        }
                                        _interests.value = List.from(i);
                                        _interestController.clear();
                                      },
                                child: Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemBlue,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(
                                      Iconsax.add,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty && _showSubmit) {
                              reBuild(() {
                                _showSubmit = false;
                              });
                            }
                            if (value.isNotEmpty && !_showSubmit) {
                              reBuild(() {
                                _showSubmit = true;
                              });
                            }
                          },
                          onFieldSubmitted: (value) {
                            List<String> i = _interests.value;
                            if (!i.contains(value)) i.add(value);
                            _interests.value = List.from(i);
                            _interestController.clear();
                          },
                        );
                      }),
                      const SizedBox(height: 8),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: ValueListenableBuilder(
                          valueListenable: _interests,
                          builder: (context, value, child) {
                            return Wrap(
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              children: value.map((e) => _chip(e)).toList(),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: _content,
                        title: "Post Content",
                        hintText: "Enter post content",
                        maxLines: 10,
                      ),
                      // SizedBox(height: 45.h),
                      const Spacer(),
                      AppButton.fromText(
                        text: "Create post",
                        onTap: () async {
                          var r = await Provider.of<PostProvider>(context,
                                  listen: false)
                              .createPost(
                            title: _title.text,
                            content: _content.text,
                            tags: _interests.value,
                          );

                          if (r && context.mounted) {
                            Navigator.pop(context);
                            return;
                          }

                          Fluttertoast.showToast(msg: "Failed to create post");
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
          ),
        ],
      ),
    );
  }

  Widget _chip(String message) {
    return ScaleButton(
      onTap: () {
        List<String> i = _interests.value;
        i.remove(message);
        _interests.value = List.from(i);
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
