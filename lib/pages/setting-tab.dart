import 'package:audioplayer/utils/keys.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/settings.dart';
import '../utils/strings.dart';

class SettingTab {
  String title;
  String desc;
  IconData icon;
  final content;
  bool row = false;

  SettingTab({
    required this.title,
    required this.icon,
    this.desc = "",
    this.content,
    this.row = false,
  });
}

class SettingTabPage extends StatefulWidget {
  late SettingTab data;
  SettingTabPage({Key? key, required this.data}) : super(key: key);

  @override
  State<SettingTabPage> createState() => SettingTabPageState();
}

class SettingTabPageState extends State<SettingTabPage>
    with WidgetsBindingObserver {
  List<Widget> content = [];

  void setupContent() {
    content = [];
    if (widget.data.content == []) return;
    setState(() {});

    for (List button in widget.data.content) {
      if (button[0].isNotEmpty) {
        if (button[0] == "Switch") {
          content.add(SwitchSetting(button: button));
        }

        if (button[0] == "Input") {
          content.add(InputSetting(button: button));
        }

        if (button[0] == "Button") {
          content.add(ButtonSetting(button: button));
        }

        if (button[0] == "ImageButton")
          content.add(ImageButton(button: button));

        if (button[0].runtimeType == String && button.length < 2) {
          content.add(Text(
            button[0],
            style: button[1] ?? const TextStyle(),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setupContent();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
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
                        icon: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Barvy.getColorFromTheme("primary"),
                        )),
                  ),
                  Text(
                    Strings().translate(widget.data.title),
                    style: const TextStyle(
                      fontSize: 21,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Barvy.getColorFromTheme("bg"),
                    child: IconButton(
                        onPressed: () {
                          Settings().switchTheme();
                        },
                        icon: Icon(
                          Icons.more_horiz_outlined,
                          color: Barvy.getColorFromTheme("primary"),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                  child: widget.data.row
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: content,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: content,
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
