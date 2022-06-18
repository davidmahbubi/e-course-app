import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchVideo extends StatelessWidget {
  final YoutubePlayerController ytController = YoutubePlayerController(
    initialVideoId: '5TOlF1cOflo',
    flags: const YoutubePlayerFlags(mute: false),
  );

  WatchVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  children: const <Widget>[
                    SizedBox(height: 10),
                    Text(
                      'Aljabar Linier',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text('Matematika Diskrit')
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
