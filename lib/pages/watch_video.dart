import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchVideo extends StatelessWidget {

  final String youtubeVideoId;
  late final YoutubePlayerController ytController;

  WatchVideo({Key? key, this.youtubeVideoId = 'azjRAEB1zXY'}) : super(key: key) {
    ytController = YoutubePlayerController(
      initialVideoId: youtubeVideoId,
      flags: const YoutubePlayerFlags(mute: false),
    );
  }

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
