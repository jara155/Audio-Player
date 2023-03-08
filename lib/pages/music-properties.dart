import 'package:audioplayer/utils/strings.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/music.dart';

class MusicProperties extends StatelessWidget {
  Music music = Music(title: "", filePath: "");
  MusicProperties({
    Key? key,
    required this.music
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double megabytes = music.rawModel.size.toDouble() / 1024 / 1024;
    String fileSize = "${megabytes.toStringAsFixed(2)} MB";


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
                    backgroundColor: Barvy.getColorFromTheme("bg"),
                    child: IconButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new_outlined, color: Barvy.getColorFromTheme("primary"),)
                    ),
                  ),
                  Text(Strings().translate("info-music"), style: const TextStyle(
                    fontSize: 21,
                  ),),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Barvy.getColorFromTheme("bg"),
                    child: IconButton(
                        onPressed: () async {

                        },
                        icon: Icon(Icons.music_note, color: Barvy.getColorFromTheme("primary"),)
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10,),
              CircleAvatar(
                radius: 105,
                backgroundColor: Barvy.getColorFromTheme("bg"),
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: primary,
                  child: Icon(Icons.music_note, size: 120, color: Barvy.getColorFromTheme("primary"),),
                ),
              ),

              const SizedBox(height: 15,),
              Text(music.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              const SizedBox(height: 7,),
              Text(music.author, style: TextStyle(fontSize: 20, color: Barvy.getColorFromTheme("primary").withOpacity(.65)),),


              const SizedBox(height: 15,),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${Strings().translate("size")}: ~$fileSize", style: const TextStyle(fontSize: 18),),
                  Text("${Strings().translate("album")}: ${music.rawModel.album}", style: const TextStyle(fontSize: 18),),
                  Text("${Strings().translate("extension")}: ${music.rawModel.fileExtension}", style: const TextStyle(fontSize: 18),),
                ],
              ),

              const SizedBox(height: 35,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {

                    },
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white, size: 45,)
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
