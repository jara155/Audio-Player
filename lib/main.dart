import 'package:flutter/material.dart';
import 'package:audioplayer/pages/loading.dart';

import 'package:audioplayer/utils/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async{

  // await Hive.initFlutter();
  // Hive.registerAdapter(TypeAdapter());
  // await OnAudioRoom().initRoom();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.dark,
      routes: {
        "/": (context) => const Loading(),
      },
    )
  );

}