import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_course_app/components/video_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:e_course_app/services/database_service.dart';

class WatchVideo extends StatefulWidget {

  final String title;
  final String subject;
  final String youtubeVideoUrl;
  late final YoutubePlayerController ytController;

  WatchVideo({Key? key, required this.title, required this.subject, required this.youtubeVideoUrl}) : super(key: key) {
    ytController = YoutubePlayerController(
      initialVideoId: YoutubePlayerController.convertUrlToId(youtubeVideoUrl)!,
      params: YoutubePlayerParams(
        showFullscreenButton: true,
        showControls: true,
      )
      // flags: const YoutubePlayerFlags(mute: false, loop: true, forceHD: true),
    );
  }

  @override
  State<WatchVideo> createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {

  List<QueryDocumentSnapshot<Object?>> videosList = [];

  void toggleLandscapeFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  void toggleLandscapeOutFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void initState() {
    super.initState();
    registerVideoDatabaseEvent();
    widget.ytController.onEnterFullscreen = () {
      toggleLandscapeFullscreen();
    };
    widget.ytController.onExitFullscreen = () {
      toggleLandscapeOutFullscreen();
    };
  }

  void registerVideoDatabaseEvent() {
    print('Re-registering event');
    DatabaseService.videoCollection().snapshots().listen((event) {
      setState(() {
        videosList = event.docs.toList();
      });
    }, onError: (error) {
        print('An error occured when fetching data');
      },
    );
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
                YoutubePlayerIFrame(
                  controller: widget.ytController,
                  aspectRatio: 16/9,
                ),
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
                      const SizedBox(height: 5),
                      Divider(),
                      const SizedBox(height: 20),
                      Text('Video Lainnya'),
                      VideoGrid(videosList: videosList, onTap: (String videoId, Map<String, dynamic> videoData) { 
                        try {
                          widget.ytController.pause();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => WatchVideo(
                            youtubeVideoUrl: videoData['youtubeUrl'],
                            title: videoData['title'],
                            subject: videoData['subject'],
                          )));
                        } catch(e) {
                          print('Navigator error $e');
                        }
                      })
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
