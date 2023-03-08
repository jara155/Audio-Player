import 'package:audioplayer/pages/player.dart';
import 'package:audioplayer/pages/settings.dart';
import 'package:audioplayer/widgets/big-button.dart';
import 'package:audioplayer/utils/colors.dart';
import 'package:audioplayer/widgets/music-row.dart';
import 'package:audioplayer/utils/music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:page_transition/page_transition.dart';

import '../utils/keys.dart';
import '../utils/settings.dart';
import '../utils/strings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<List> tempMusics;
  late Future<List> musics;
  List favoriteMusics = [];
  List lastPlayed = [];
  int musicsLength = 0;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool isFocused = false;

  String selected = "music";

  bool sortAZ = false;
  bool shuffle = false;

  void refresh() {
    tempMusics.then((value) => musicsLength = value.length);
    setState(() {
      if (selected != "favorite") {
        musics = Music.getMusic();
        tempMusics = musics;
      } else {
        getFavoriteMusic();
        musics = Future.value(favoriteMusics);
      }
    });
  }

  void getFavoriteMusic() {
    List<String> titles = Settings().getSetting("favoriteMusic").split(",");
    favoriteMusics = [];
    tempMusics.then((value) {
      for (Music music in value) {
        if (!titles.contains(music.title)) continue;
        if (!favoriteMusics.contains(music)) favoriteMusics.add(music);
      }
    });
  }

  void search(String input) {
    tempMusics.then((value) async {
      List searchedMusics = await value
          .where((element) =>
              element.title.toString().toLowerCase().startsWith(input))
          .toList();
      musics = Future.value(searchedMusics);
      setState(() {});
    });
  }

  void updateLastPlayed(Music music) {
    if (lastPlayed.contains(music)) return;

    if (lastPlayed.length == 5) lastPlayed.removeLast();
    lastPlayed.add(music);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    musics = Music.getMusic();
    tempMusics = musics;

    getFavoriteMusic();
    refresh();

    tempMusics.then((value) => musicsLength = value.length);

    // play pause stop
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onPlayerComplete.listen((state) {
      if (audioPlayer.releaseMode == ReleaseMode.loop) {
        Music.play(playing);
        return;
      }

      Music.skipToNext();
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
      if (playerKey.currentState != null)
        playerKey.currentState!.setState(() {});
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
      if (playerKey.currentState != null)
        playerKey.currentState!.setState(() {});
    });
  }

  Music playing = Music(title: "", author: "", filePath: "");
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // getFavoriteMusic();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            color: Settings().defaultPrimaryColor(),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                      ),
                      Text(
                        Strings().translate("music"),
                        style: const TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Barvy.getColorFromTheme("bg"),
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    child: const SettingsPage(),
                                    opaque: true,
                                  ));
                            },
                            icon: Icon(
                              Icons.settings,
                              color: Barvy.getColorFromTheme("primary"),
                              size: 28,
                            )),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getFavoriteMusic();
                          musics = Future.value(favoriteMusics);
                          setState(() {
                            selected = "favorite";
                          });
                        },
                        child: BigContainer(
                          title: Strings().translate("favorite-music"),
                          isSelected: selected == "favorite",
                          count: Settings()
                                  .getSetting("favoriteMusic")
                                  .split(",")
                                  .length -
                              1,
                          icon: LineIcon.heartAlt().icon,
                          iconBgColor: Barvy.getColorFromTheme("bg"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          musics = tempMusics;
                          setState(() {
                            selected = "music";
                          });
                        },
                        child: BigContainer(
                          title: Strings().translate("music"),
                          isSelected: selected == "music",
                          count: musicsLength,
                          icon: Icons.music_note,
                          iconBgColor: Barvy.getColorFromTheme("bg"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          musics = Future.value(lastPlayed);
                          setState(() {
                            selected = "last-played";
                          });
                        },
                        child: BigContainer(
                          title: Strings().translate("last-played"),
                          isSelected: selected == "last-played",
                          icon: LineIcon.play().icon,
                          count: lastPlayed.length,
                          iconBgColor: Barvy.getColorFromTheme("bg"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  TextField(
                    controller: searchController,
                    autofocus: false,
                    onChanged: (output) {
                      output = output.toLowerCase();

                      search(output);
                    },
                    onSubmitted: (output) {
                      output = output.toLowerCase();

                      search(output);
                    },
                    decoration: InputDecoration(
                      hintText: Strings().translate("search"),
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
                      suffixIcon: searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchController.text = "";
                                  search("");
                                });
                              },
                              child: const Icon(Icons.close),
                            )
                          : const Text(""),
                      contentPadding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(maxHeight: 45),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Strings().translate("local-musics"),
                          style: const TextStyle(fontSize: 19),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (!sortAZ) {
                                    sortAZ = true;
                                    musics.then((value) {
                                      value.sort(
                                          (a, b) => a.title.compareTo(b.title));
                                    });
                                  } else {
                                    sortAZ = false;
                                    musics.then((value) {
                                      value.sort(
                                          (a, b) => b.title.compareTo(a.title));
                                    });
                                  }
                                });
                              },
                              child: Icon(
                                sortAZ
                                    ? LineIcon.sortAlphabeticalDown().icon
                                    : LineIcon.sortAlphabeticalUp().icon,
                                size: 32,
                                color: primary,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  Divider(
                      height: 5,
                      thickness: 2,
                      color: Settings().defaultPrimaryColor()),

                  const SizedBox(
                    height: 5,
                  ),

                  // const SizedBox(height: 5,),

                  FutureBuilder(
                    future: musics,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Flexible(
                          child: ListView(
                            children: [
                              for (Music song in snapshot.data!)
                                MusicRow(
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

                  const SizedBox(
                    height: 10,
                  )
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
          Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: MusicPlayer(
                  key: playerKey,
                  music: playing,
                ),
                opaque: true,
              ));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: playing.title == "" ? 0 : 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Barvy.getColorFromTheme("bg"),
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
                        Text(
                          playing.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          playing.author,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    CircleAvatar(
                        radius: 25,
                        child: IconButton(
                          icon: isPlaying
                              ? const AnimatedSwitcher(
                                  duration: Duration(milliseconds: 450),
                                  child: Icon(
                                    Icons.pause_rounded,
                                    color: Colors.green,
                                  ))
                              : const AnimatedSwitcher(
                                  duration: Duration(milliseconds: 450),
                                  child: Icon(Icons.play_arrow_rounded)),
                          onPressed: () async {
                            if (isPlaying) {
                              await audioPlayer.pause();
                            } else {
                              await audioPlayer.resume();
                            }
                            setState(() {});
                          },
                          iconSize: 30,
                        )),
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
                        end: ((position.inSeconds / duration.inSeconds) * 100) /
                            100,
                      ),
                      builder: (ctx, value, _) => LinearProgressIndicator(
                          value: isPlaying ? value : 0,
                          minHeight: 2,
                          color: Settings().defaultPrimaryColor()),
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
