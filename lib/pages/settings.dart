import 'package:audioplayer/utils/settings.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/big-button.dart';
import '../widgets/row-button.dart';
import '../utils/strings.dart';
import 'setting-tab.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Barvy.getColorFromTheme("bg"),
                    child: IconButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new_outlined, color: Barvy.getColorFromTheme("primary"),)
                    ),
                  ),
                  Text(Strings().translate("settings"), style: const TextStyle(
                    fontSize: 21,
                  ),),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Barvy.getColorFromTheme("bg"),
                    child: IconButton(
                        onPressed: () {
                        },
                        icon: Icon(Icons.more_horiz_outlined, color: Barvy.getColorFromTheme("primary"),)
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20,),

              Flexible(
                child: Column(
                  children: [
                    for(SettingTab tab in Settings().tabs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: RowButton(
                              data: tab
                            )
                          ),
                        ),
                      )


                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
