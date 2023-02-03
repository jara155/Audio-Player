import 'dart:io';
import 'dart:math';

import 'package:audioplayer/utils/keys.dart';
import 'package:audioplayer/utils/strings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class Music {
  String title = "";
  String author = "";
  String img = "";
  final rawModel;
  final filePath;

  Music({
    required this.title,
    required this.filePath,
    this.rawModel,
    this.img = "assets/images/music-icon.png",
    this.author = "Anonymní",
  });

  static Future<List<Music>> getMusic() async {

    // List<Permissions> permissions = await Permission.getPermissionStatus([PermissionName.Storage]);
    // permissions.forEach((p) async {
    //   if(p.permissionStatus != PermissionStatus.allow){
    //     final res = await Permission.requestSinglePermission(PermissionName.Storage);
    //     print(res);
    //   }
    // });

    Permission.storage.request();

    final audioQuery = OnAudioQuery();

    List<Music> songs = [];

    audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true
    ).then((value) {

      for (SongModel song in value) {
        // if(song.album != "Songy") continue;

        String title = song.title;
        String author = "Neuveden";
        if(song.title.contains(" - ")) {
          title = song.displayNameWOExt.split(" - ")[1];
          author = song.displayNameWOExt.split(" - ")[0];
        }

        title = title
            .replaceAll(RegExp(r'\(.*\)'), '')
            .replaceAll(RegExp(r'\[.*\]'), '')
            .replaceAll("OFFICIAL MUSIC VIDEO", "");

        if(title.contains("final")) continue;

        if(title.contains(" ft")) {
          author = "$author, ${title.substring(title.indexOf(" ft") + 4).trim()}";
          title = title.replaceAll(title.substring(title.indexOf(" ft")).trim(), "");
        }

        if(author.contains(" & ")) {
          List authors = author.split(" & ");
          author = "";
          author = authors.join(", ");
        }

        if(author.contains(" x ") || author.contains(" X ")) {
          List authors = author.split(" x ");
          author = "";
          author = authors.join(", ");
        }

        songs.add(
            Music(
              title: title,
              filePath: song.data,
              author: author,
              rawModel: song
            )
        );
      }

      songs.sort((a,b) => b.rawModel.dateModified.compareTo(a.rawModel.dateModified));

    });


    return songs;

  }

  static Future play(Music music) async {
    homeKey.currentState!.playing = music;
    homeKey.currentState!.audioPlayer.stop();
    homeKey.currentState!.audioPlayer.play(DeviceFileSource(music.filePath));
    homeKey.currentState!.audioPlayer.resume();
  }

  static Future stop() async {
    homeKey.currentState!.audioPlayer.stop();
    homeKey.currentState!.playing = Music(title: "", filePath: "");
    homeKey.currentState!.position = Duration.zero;
    homeKey.currentState!.duration = Duration.zero;
  }

  static bool isPlaying(Music music) {
    return music.title == homeKey.currentState!.playing.title;
  }

  static Future skipToNext() async {
    homeKey.currentState!.musics.then((value) {
      Music next = value[value.indexOf(homeKey.currentState!.playing)+1];
      if(homeKey.currentState!.shuffle) {
        next = value.elementAt(Random().nextInt(value.length));
      }
      Music.play(next);
      if(playerKey.currentState != null) {
        playerKey.currentState!.playing = next;
        playerKey.currentState!.setState(() {});
      }
      homeKey.currentState!.audioPlayer.resume();
      homeKey.currentState!.setState(() {});
    });
  }

  static Future skipToLast() async {
    homeKey.currentState!.musics.then((value) {
      Music last = value[value.indexOf(homeKey.currentState!.playing)-1];
      Music.play(last);
      playerKey.currentState!.playing = last;
      homeKey.currentState!.audioPlayer.resume();
      homeKey.currentState!.setState(() {});
      playerKey.currentState!.setState(() {});
    });
  }

}