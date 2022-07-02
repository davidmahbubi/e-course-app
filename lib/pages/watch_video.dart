import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchVideo extends StatefulWidget {

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

  @override
  State<WatchVideo> createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {

  bool _isPlaying = false;

  void toggleLandscapeFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    widget.ytController.toggleFullScreenMode();  
    setState(() {
      _isPlaying = true;
    });
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
                YoutubePlayer(
                  controller: widget.ytController,
                  onReady: toggleLandscapeFullscreen,
                ),
                if (!_isPlaying)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Text(
                        widget.title, style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(widget.subject),
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
