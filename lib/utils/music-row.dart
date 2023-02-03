
import 'package:audioplayer/pages/player.dart';
import 'package:audioplayer/utils/colors.dart';
import 'package:audioplayer/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'music.dart';

class MusicRow extends StatelessWidget {
  Music music = Music(title: "", filePath: "");
  MusicRow({
    Key? key,
    required this.music,
  }) : super(key: key);

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, PageTransition(
            type: PageTransitionType.bottomToTop,
            child: MusicPlayer(key: playerKey, music: music,),
            opaque: true,
          ));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 75,
          decoration: BoxDecoration(
            color: Music.isPlaying(music) ? Colors.green : darkPrimary.withOpacity(.1),
            borderRadius: BorderRadius.circular(18)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(music.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                      Text(music.author, style: TextStyle(fontSize: 16, color: darkPrimary.withOpacity(.65)),),
                    ],
                  ),
                ),

                CircleAvatar(
                    radius: 25,
                    child: IconButton(
                      icon: Music.isPlaying(music)
                          ? const AnimatedSwitcher(duration: Duration(milliseconds: 450), child: Icon(Icons.stop_rounded, color: Colors.green,))
                          : const AnimatedSwitcher(duration: Duration(milliseconds: 450), child: Icon(Icons.play_arrow_rounded)),
                      onPressed: () async {
                        homeKey.currentState!.setState(() {
                          if(homeKey.currentState!.playing.title != music.title) {
                            Music.play(music);
                            return;
                          }

                          if(homeKey.currentState!.playing.title == music.title) {
                            Music.stop();
                            return;
                          }
                        });

                      },
                      iconSize: 30,
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
