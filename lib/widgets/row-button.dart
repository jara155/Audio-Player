
import 'package:audioplayer/utils/colors.dart';
import 'package:audioplayer/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../pages/setting-tab.dart';

class RowButton extends StatelessWidget {
  late SettingTab data;
  RowButton({
    Key? key,
    required this.data
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: SettingTabPage(data: data,),
            opaque: true,
          ));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 75,
          decoration: BoxDecoration(
            color: Barvy.getColorFromTheme("secondary"),
            borderRadius: BorderRadius.circular(18)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 25,
                    child: Icon(
                        data.icon
                    )
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(Strings().translate(data.title), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                      Text(Strings().translate(data.desc), style: TextStyle(fontSize: 16, color: Barvy.getColorFromTheme("primary").withOpacity(.65)),),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
