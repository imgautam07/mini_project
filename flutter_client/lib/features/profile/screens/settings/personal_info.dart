import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/utils.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key, required this.tech, required this.prof, required this.exp});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();

  final List<String> tech;
  final List<String> prof;
  final String exp;
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  File? pickedFile;
  final bool _isLoading = false;

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
            child: Consumer<AuthServices>(builder: (context, value, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        AppImages.back,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    title: const Text("Personal info"),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: ScaleButton(
                      onTap: _isLoading
                          ? null
                          : () async {
                              showLoadingDialog(context);

                              var r = await sourceSelect(context);
                              if (r != null) {
                                var img1 =
                                    await ImagePicker().pickImage(source: r);
                                if (img1 != null) {
                                  var img2 = await ImageCropper().cropImage(
                                      sourcePath: img1.path,
                                      aspectRatio: const CropAspectRatio(
                                          ratioX: 1, ratioY: 1));

                                  if (img2 != null) {
                                    pickedFile = File(img2.path);
                                    setState(() {});
                                  }
                                }
                              }

                              if (context.mounted) Navigator.pop(context);
                            },
                      child: SizedBox(
                        height: 175.h,
                        width: 175.h,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Image(
                                  image: pickedFile != null
                                      ? FileImage(pickedFile!)
                                      : const NetworkImage(
                                          'url',
                                        ),
                                  fit: BoxFit.cover,
                                  height: 160.w,
                                  width: 160.w,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 30.w,
                                width: 30.w,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
