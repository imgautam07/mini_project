import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/buttons/scale_button.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/common/widgets/custom_textfield.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/root_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key, required this.data});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
  final Map<String, dynamic> data;
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final TextEditingController _nameController = TextEditingController();
  final _fKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServices>(builder: (context, value, _) {
      return Scaffold(
        floatingActionButton: ScaleButton(
          onTap: _isLoading
              ? null
              : () async {
                  if (_fKey.currentState?.validate() ?? false) {
                    _isLoading = true;
                    setState(() {});

                    widget.data['name'] = _nameController.text;
                    var r =
                        await Provider.of<AuthServices>(context, listen: false)
                            .postProfile(widget.data);

                    _isLoading = false;
                    setState(() {});

                    if (r && context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const RootScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  }
                },
          child: Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFEFEFE).withOpacity(.1),
            ),
            child: _isLoading
                ? const CupertinoActivityIndicator()
                : Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24.w,
                  ),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppImages.questionBg,
              fit: BoxFit.cover,
            ),
            Image.asset(
              AppImages.noiseImage,
              fit: BoxFit.cover,
            ),
            const Positioned(
              child: Row(),
            ),
            Positioned.fill(
              left: 16.w,
              right: 16.w,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  leading: IconButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: const Text("Profile info"),
                ),
                body: Form(
                  key: _fKey,
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _nameController,
                        enabled: !_isLoading,
                        title: "First Name",
                        hintText: "Type Name",
                        validator: (value) {
                          value = value?.trim();
                          _nameController.text = value ?? "";
                          if (value == null || value.isEmpty) {
                            return "Enter your name";
                          }
                          if (value.length < 3) {
                            return "Must have at least 3 chars";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
