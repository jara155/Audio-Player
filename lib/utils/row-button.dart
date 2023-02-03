import 'package:audioplayer/utils/settings.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class RowButton extends StatefulWidget {
  const RowButton({Key? key}) : super(key: key);

  @override
  State<RowButton> createState() => _RowButtonState();
}

class _RowButtonState extends State<RowButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 170,
      height: 80,
      duration: Duration(milliseconds: 150),
      decoration: BoxDecoration(
          color: darkPrimary.withOpacity(.2),
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
                    backgroundColor: primary,
                    radius: 19,
                    child: Icon(Icons.heart_broken_outlined, color: darkPrimary, size: 30,),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Oblíbené",
                  style: TextStyle(
                      letterSpacing: .2,
                      color: darkPrimary.withOpacity(.8)),
                ),
              ],
            ),
            Text(
              "0",
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
