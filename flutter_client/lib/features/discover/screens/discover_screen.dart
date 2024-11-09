import 'package:flutter_client/common/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
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
            titleSpacing: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: 205.h,
            title: AtonAppBar(
              title: "Discover",
              defaultSelectedOption: "All",
              bottomOptions: [
                AppBarOption(title: "All"),
                AppBarOption(title: "Developers"),
                AppBarOption(title: "Designers"),
              ],
              onSelect: (value) {
                setState(() {
                  _selected = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
