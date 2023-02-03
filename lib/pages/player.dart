import 'dart:typed_data';

import 'package:audioplayer/pages/music-properties.dart';
import 'package:audioplayer/utils/keys.dart';
import 'package:audioplayer/utils/music.dart';
import 'package:audioplayer/utils/settings.dart';
import 'package:audioplayer/utils/strings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:line_icons/line_icon.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/extensions/entity_checker_extension.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/colors.dart';


class MusicPlayer extends StatefulWidget {
  Music music = Music(title: "", filePath: "");

   MusicPlayer({
    Key? key,
    required this.music,
  }) : super(key: key);

  @override
  State<MusicPlayer> createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  List musics = [];

  late Music playing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    playing = widget.music;

    if(homeKey.currentState!.playing.title != playing.title) homeKey.currentState!.duration = playing.rawModel.duration;

    homeKey.currentState!.musics.then((value) {
      musics = value;
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
                    backgroundColor: darkPrimary.withOpacity(.2),
                    child: IconButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new_outlined, color: darkPrimary,)
                    ),
                  ),
                  const Text("Přehrávač", style: TextStyle(
                    fontSize: 21,
                  ),),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: darkPrimary.withOpacity(.2),
                    child: IconButton(
                        onPressed: () async {
                          Navigator.push(context, PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: MusicProperties(music: playing,),
                            opaque: true,
                          ));
                        },
                        icon: Icon(Icons.more_horiz_outlined, color: darkPrimary,)
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50,),

              // Text(Strings.formatTime(position)),
              const SizedBox(height: 5,),
              CircleAvatar(
                radius: 167,
                backgroundColor: darkPrimary.withOpacity(.7),
                child: CircleAvatar(
                  radius: 165,
                  backgroundColor: primary,
                  child: Icon(Icons.music_note, size: 190, color: darkPrimary,),
                ),
              ),

              const SizedBox(height: 25,),

              Text(playing.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              const SizedBox(height: 7,),
              Text(playing.author, style: TextStyle(fontSize: 20, color: darkPrimary.withOpacity(.65)),),

              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                tween: Tween<double>(
                  begin: 10,
                  end: homeKey.currentState!.position.inSeconds.toDouble(),
                ),
                builder: (ctx, value, _) => Slider(
                  activeColor: primary,
                  min: 0,
                  max: homeKey.currentState!.duration.inSeconds.toDouble(),
                  value: value,
                  onChanged: (value) async {
                    final pos = Duration(seconds: value.toInt());
                    await homeKey.currentState!.audioPlayer.seek(pos);
                    homeKey.currentState!.position = pos;
                    setState(() {});
                    // await audioPlayer.resume();
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Strings.formatTime(homeKey.currentState!.position)),
                    Text(Strings.formatTime(homeKey.currentState!.duration)),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: darkPrimary.withOpacity(.2),
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          if(homeKey.currentState!.audioPlayer.releaseMode != ReleaseMode.loop) {
                            homeKey.currentState!.audioPlayer.setReleaseMode(ReleaseMode.loop);
                          } else {
                            homeKey.currentState!.audioPlayer.setReleaseMode(ReleaseMode.release);
                          }
                        });
                      },
                      icon: homeKey.currentState!.audioPlayer.releaseMode == ReleaseMode.loop
                          ? const Icon(Icons.repeat_one, color: Colors.green,)
                          : Icon(Icons.repeat, color: darkPrimary)
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: darkPrimary.withOpacity(.2),
                    child: IconButton(
                      onPressed: () async {

                      },
                      icon: Icon(LineIcon.heart().icon, color: Colors.red,)
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: darkPrimary.withOpacity(.2),
                    child: IconButton(
                      onPressed: () {
                        homeKey.currentState!.shuffle = !homeKey.currentState!.shuffle;
                        setState(() {});
                        homeKey.currentState!.setState(() {});
                      },
                      icon: Icon(LineIcon.random().icon, color: homeKey.currentState!.shuffle ? Colors.green : darkPrimary,)
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(musics.indexOf(playing)-1 != -1)
                    CircleAvatar(
                        radius: 40,
                        backgroundColor: darkPrimary.withOpacity(.2),
                        child: IconButton(
                          icon: Icon(Icons.keyboard_double_arrow_left_sharp, color: darkPrimary,),
                          onPressed: () async {
                            Music.skipToLast();
                          },
                          iconSize: 50,
                        )
                    ),
                  if(musics.indexOf(playing)-1 == -1)
                    const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                    ),

                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: IconButton(
                      color: darkPrimary,
                      icon: Music.isPlaying(playing) && homeKey.currentState!.isPlaying
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow_rounded),
                      iconSize: 50,
                      onPressed: () async {
                        if (homeKey.currentState!.isPlaying) {
                          await homeKey.currentState!.audioPlayer.pause();
                        } else {
                          await homeKey.currentState!.audioPlayer.resume();
                        }
                        setState(() {});
                      },
                    )
                  ),

                  if(musics.indexOf(playing)+1 != musics.length)
                    CircleAvatar(
                        radius: 40,
                        backgroundColor: darkPrimary.withOpacity(.2),
                        child: IconButton(
                          icon: Icon(Icons.keyboard_double_arrow_right_sharp, color: darkPrimary,),
                          onPressed: () async{
                            Music.skipToNext();
                          },
                          iconSize: 50,
                        )
                    ),
                  if(musics.indexOf(playing)+1 == musics.length)
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                    ),
                ],
              )


            ],
          ),
        ),
      ),
    );
  }
}
