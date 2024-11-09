// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AppDropDown extends StatefulWidget {
  const AppDropDown({
    super.key,
    required this.entries,
    required this.onEntrySelected,
    required this.hintText,
    this.selected,
  });

  @override
  State<AppDropDown> createState() => _AppDropDownState();

  final List<AppDropDownEntry> entries;
  final Function(AppDropDownEntry value) onEntrySelected;
  final String hintText;
  final List<String>? selected;
}

class _AppDropDownState extends State<AppDropDown> {
  bool isOpen = false;
  AppDropDownEntry? selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 18.w,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.1),
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(
            color: Colors.grey.withOpacity(.1),
            width: 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    (selected == null || widget.selected != null)
                        ? widget.hintText
                        : selected!.label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: selected == null
                          ? Colors.grey.withOpacity(.5)
                          : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 10.w),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastEaseInToSlowEaseOut,
                  turns: isOpen ? .5 : 1,
                  child: SvgPicture.asset('assets/svgs/chevron.svg'),
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastEaseInToSlowEaseOut,
              height: isOpen ? 8.h : 0,
            ),
            AnimatedCrossFade(
              firstChild: SizedBox(
                height: widget.entries.length < 8
                    ? ((widget.entries.length * 24) +
                        (4 * (widget.entries.length - 1)))
                    : ((24 * 9) + (4 * 8)),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: widget.entries.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    var item = widget.entries[index];

                    return _Entry(
                      item: item,
                      onSelect: () {
                        setState(() {
                          selected = item;
                        });
                        widget.onEntrySelected.call(item);

                        if (widget.selected == null) {
                          isOpen = false;
                          setState(() {});
                        }
                      },
                      selected: widget.selected == null
                          ? (selected?.value == item.value)
                          : widget.selected!.contains(item.value),
                    );
                  },
                ),
              ),
              secondChild: const SizedBox(
                width: double.infinity,
                height: 0,
              ),
              crossFadeState:
                  isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 400),
              sizeCurve: Curves.fastEaseInToSlowEaseOut,
              firstCurve: Curves.fastEaseInToSlowEaseOut,
              secondCurve: Curves.fastEaseInToSlowEaseOut,
            ),
          ],
        ),
      ),
    );
  }
}

class _Entry extends StatefulWidget {
  const _Entry({
    required this.item,
    required this.selected,
    required this.onSelect,
  });

  final AppDropDownEntry item;
  final bool selected;
  final VoidCallback onSelect;

  @override
  State<_Entry> createState() => _EntryState();
}

class _EntryState extends State<_Entry> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 100));
        widget.onSelect();
      },
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) async {
        await Future.delayed(const Duration(milliseconds: 125));
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () async {
        await Future.delayed(const Duration(milliseconds: 125));
        setState(() {
          isPressed = false;
        });
      },
      child: Container(
        height: 24,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: widget.selected
              ? const Color(0xFF9452FF).withOpacity(.3)
              : !isPressed
                  ? Colors.grey.withOpacity(0)
                  : Colors.grey.withOpacity(.05),
        ),
        child: Row(
          children: [
            Text(widget.item.label),
          ],
        ),
      ),
    );
  }
}

class AppDropDownEntry {
  final String label;
  final String value;
  final bool enabled;
  AppDropDownEntry({
    required this.label,
    required this.value,
    this.enabled = true,
  });
}
