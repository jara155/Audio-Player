import 'package:audioplayer/utils/colors.dart';
import 'package:audioplayer/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../pages/setting-tab.dart';

class Settings {
  final box = GetStorage();

  List tabs = [
    SettingTab(
        title: "customisation",
        icon: Icons.format_paint,
        desc: "customisation-desc",
        content: [
          ["Switch", "Noční mod", "darkMode", true],
          // ["Input", "Primární barva", "primaryColor"]
        ]),
    // SettingTab(title: "Rozložení", icon: Icons.layers, desc: "Layout aplikace"),

    SettingTab(
        title: "language",
        icon: Icons.language,
        desc: "language-desc",
        row: true,
        content: [
          ["ImageButton", Icons.language_rounded, "language", "en-US"],
          ["ImageButton", Icons.language_rounded, "language", "cs-CZ"],
          ["ImageButton", Icons.language_rounded, "language", "pl-PL"],
        ]),
  ];

  void firstTime() {
    for (SettingTab tab in tabs) {
      String setting = tab.content[0][2];
      var defaultValue = tab.content[0][tab.content[0].length - 1];
      Settings().setSetting(setting, defaultValue);
    }
    Settings().setSetting("favoriteMusic", "");
  }

  String defaultLanguage() => box.read("language") ?? "en-US";
  Color defaultPrimaryColor() => box.read("primaryColor") ?? primary;

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => box.read("darkMode") ?? false;

  getSetting(key) => box.read(key) ?? "Didnt found";
  setSetting(key, value) => box.write(key, value);

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    setSetting("darkMode", !_loadThemeFromBox());
  }
}

class SwitchSetting extends StatefulWidget {
  final List button;
  const SwitchSetting({
    Key? key,
    required this.button,
  }) : super(key: key);

  @override
  State<SwitchSetting> createState() => _SwitchSettingState();
}

class _SwitchSettingState extends State<SwitchSetting> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${widget.button[1]}",
          style: const TextStyle(fontSize: 20),
        ),
        Switch(
            activeColor: primary,
            value: Settings().getSetting(widget.button[2]),
            onChanged: (bool stav) {
              if (widget.button[2] == "darkMode") {
                Settings().switchTheme();
                setState(() {});
                return;
              }
              // Settings().switchTheme();
              Settings().setSetting(widget.button[2], stav);
              setState(() {});
            }),
      ],
    );
  }
}

class ImageButton extends StatefulWidget {
  final List button;
  ImageButton({Key? key, required this.button}) : super(key: key);

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Settings().setSetting(widget.button[2], widget.button[3]);
          setState(() {});
          Navigator.pop(context);
          Navigator.pop(context);
          homeKey.currentState!.setState(() {});
        },
        child: Container(
          width: 90,
          height: 70,
          decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: Settings().getSetting(widget.button[2]) ==
                          widget.button[3]
                      ? 5
                      : 0,
                  color: primary)),
          child: Image.asset(
            "assets/images/flags/${widget.button[3]}.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class ButtonSetting extends StatefulWidget {
  final List button;
  ButtonSetting({Key? key, required this.button}) : super(key: key);

  @override
  State<ButtonSetting> createState() => _ButtonSettingState();
}

class _ButtonSettingState extends State<ButtonSetting> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Settings().setSetting(widget.button[2], widget.button[3]);
          setState(() {});
          homeKey.currentState!.setState(() {});
        },
        child: Container(
          width: 90,
          height: 70,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            widget.button[1],
            color: Barvy.getColorFromTheme("primary"),
          ),
        ),
      ),
    );
  }
}

class InputSetting extends StatelessWidget {
  final List button;
  InputSetting({Key? key, required this.button}) : super(key: key);

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${button[1]}",
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "${button[1]}",
                fillColor: Barvy.getColorFromTheme("secondary"),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xff9398a4),
                ),
                contentPadding: const EdgeInsets.all(15),
                constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                Settings().setSetting(button[2], textController.text);
                textController.text = "";
              },
              child: Icon(
                Icons.done,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
