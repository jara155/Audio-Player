import 'package:audioplayer/utils/settings.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class BigContainer extends StatefulWidget {
  String title;
  int count;
  IconData? icon;
  Color iconBgColor;
  Color selectedColor;
  List items;
  bool isSelected;

  BigContainer({
    Key? key,
    required this.title,
    this.count = 0,
    required this.icon,
    this.iconBgColor = Colors.white,
    this.selectedColor = Colors.white,
    this.items = const [],
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<BigContainer> createState() => _RowButtonState();
}

class _RowButtonState extends State<BigContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 165,
      height: 80,
      duration: Duration(milliseconds: 150),
      decoration: BoxDecoration(
          color: widget.isSelected ? primary : Barvy.getColorFromTheme("secondary"),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: primary,
                  radius: 20,
                  child: CircleAvatar(
                    backgroundColor: widget.iconBgColor,
                    radius: 19,
                    child: Icon(widget.icon, color: primary, size: 25,),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                      letterSpacing: .2,
                      color: Barvy.getColorFromTheme("primary").withOpacity(.8)),
                ),
              ],
            ),
            Text(
              "${widget.count}",
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
