import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchVideo extends StatelessWidget {
  final YoutubePlayerController ytController = YoutubePlayerController(
    initialVideoId: 'azjRAEB1zXY',
    flags: const YoutubePlayerFlags(mute: false),
  );

  WatchVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    ytController.toggleFullScreenMode();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YoutubePlayer(controller: ytController),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    const Text(
                      'Cara Kerja Mobile Phone',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text('Science Terapan'),
                    FullScreenButton(controller: ytController)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
