import 'package:audioplayer/utils/settings.dart';
import 'package:flutter/material.dart';
import 'package:audioplayer/pages/loading.dart';

import 'package:audioplayer/utils/theme.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();

  // Settings().box.erase();
  if (Settings().box.getKeys().toString() == "()") Settings().firstTime();
  
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: Themes.light,
    darkTheme: Themes.dark,
    themeMode: Settings().theme,
    routes: {
      "/": (context) => const Loading(),
    },
  ));
}
