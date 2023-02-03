import 'package:audioplayer/pages/player.dart';
import 'package:audioplayer/utils/colors.dart';
import 'package:audioplayer/utils/music-row.dart';
import 'package:audioplayer/utils/music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:page_transition/page_transition.dart';

import '../utils/keys.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {

  late Future<List> tempMusics;
  late Future<List> musics;
  List favoriteMusics = [];

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool isFocused = false;

  bool sortAZ = false;
  bool shuffle = false;

  void refresh() {
    setState(() {
      musics = Music.getMusic();
      tempMusics = musics;
    });
  }

  void search(String input) {
    tempMusics.then((value) async {
      List searchedMusics = await value.where(
              (element) => element.title.toString().toLowerCase().startsWith(input)).toList();
      musics = Future.value(searchedMusics);
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refresh();

    // play pause stop
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onPlayerComplete.listen((state) {
      if(audioPlayer.releaseMode == ReleaseMode.loop) {
        Music.play(playing);
        return;
      }

      Music.skipToNext();
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
      if(playerKey.currentState != null) playerKey.currentState!.setState(() {});
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
      if(playerKey.currentState != null) playerKey.currentState!.setState(() {});
    });

  }

  Music playing = Music(title: "", author: "", filePath: "");
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            color: primary,
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Hudba", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),)
                    ],
                  ),

                  // const SizedBox(height: 5,),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     RowButton(),
                  //     const SizedBox(width: 10,),
                  //     RowButton(),
                  //   ],
                  // ),

                  const SizedBox(height: 10,),

                  TextField(
                    controller: searchController,
                    autofocus: false,
                    onChanged: (output) {

                      output = output.toLowerCase();

                      search(output);

                    },
                    decoration: InputDecoration(
                      hintText: "Vyhledat",
                      fillColor: darkSecondary.withOpacity(.25),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.search, color: Color(0xff9398a4),),
                      suffixIcon: searchController.text.isNotEmpty ? GestureDetector(
                        onTap: () {
                          setState(() {
                            searchController.text = "";
                            search("");
                          });
                        },
                        child: const Icon(Icons.close),
                      ) : const Text(""),
                      contentPadding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(maxHeight: 45),
                    ),

                  ),

                  const SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Lokální songy", style: TextStyle(fontSize: 19),),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if(!sortAZ) {
                                    sortAZ = true;
                                    musics.then((value) {
                                      value.sort((a,b) => a.title.compareTo(b.title));
                                    });
                                  } else {
                                    sortAZ = false;
                                    musics.then((value) {
                                      value.sort((a,b) => b.title.compareTo(a.title));
                                    });
                                  }
                                });
                              },
                              child: Icon(sortAZ ? LineIcon.sortAlphabeticalDown().icon : LineIcon.sortAlphabeticalUp().icon, size: 32, color: primary,),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 5, thickness: 2, color: primary,),

                  const SizedBox(height: 5,),

                  // const SizedBox(height: 5,),

                  FutureBuilder(
                    future: musics,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return Flexible(
                          child: ListView(
                            children: [
                              for (Music song in snapshot.data!) MusicRow(
                                music: song,
                              )
                            ],
                          ),
                        );
                      } else {
                        return const Text("");
                      }
                    },
                  ),

                  const SizedBox(height: 10,)

                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onVerticalDragEnd: (x) {
          Music.stop();
        },
        onTap: () {
          Navigator.push(context, PageTransition(
            type: PageTransitionType.bottomToTop,
            child: MusicPlayer(key: playerKey, music: playing,),
            opaque: true,
          ));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: playing.title == "" ? 0 : 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: darkBg,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(playing.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        Text(playing.author, style: const TextStyle(fontSize: 18),),
                      ],
                    ),

                    CircleAvatar(
                        radius: 25,
                        child: IconButton(
                          icon: isPlaying
                              ? const AnimatedSwitcher(duration: Duration(milliseconds: 450), child: Icon(Icons.pause_rounded, color: Colors.green,))
                              : const AnimatedSwitcher(duration: Duration(milliseconds: 450), child: Icon(Icons.play_arrow_rounded)),
                          onPressed: () async {
                            if (isPlaying) {
                              await audioPlayer.pause();
                            } else {
                              await audioPlayer.resume();
                            }
                            setState(() {});
                          },
                          iconSize: 30,
                        )
                    ),

                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    height: 2,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                      tween: Tween<double>(
                        begin: 0,
                        end: ((position.inSeconds / duration.inSeconds) * 100) / 100,
                      ),
                      builder: (ctx, value, _) => LinearProgressIndicator(
                        value: isPlaying ? value : 0,
                        minHeight: 2,
                        color: primary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
