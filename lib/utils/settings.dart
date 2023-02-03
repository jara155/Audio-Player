// import 'package:hive_flutter/hive_flutter.dart';
//
// class Settings {
//
//   var settingsDB = Hive.openBox("settings").then((value) => value);
//
//   get(String key) {
//     return settingsDB.then((value) => value.get(key));
//   }
//
//   void set(String key, value) {
//     settingsDB.then((value) {
//       if(value.containsKey(key)) value.delete(key);
//       value.put(key, value);
//     });
//
//   }
//
//
// }