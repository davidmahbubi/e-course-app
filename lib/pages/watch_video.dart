import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchVideo extends StatelessWidget {

  final String title;
  final String subject;
  final String youtubeVideoId;
  late final YoutubePlayerController ytController;

  WatchVideo({Key? key, required this.title, required this.subject, this.youtubeVideoId = 'azjRAEB1zXY'}) : super(key: key) {
    ytController = YoutubePlayerController(
      initialVideoId: youtubeVideoId,
      flags: const YoutubePlayerFlags(mute: false, loop: true),
    );
  }

  void toggleLandscapeFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    ytController.toggleFullScreenMode();  
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoutubePlayer(controller: ytController, onReady: toggleLandscapeFullscreen, aspectRatio: 16 / 9),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Text(
                        title, style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(subject),
                      const SizedBox(height: 200),
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
