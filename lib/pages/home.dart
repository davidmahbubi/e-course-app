import 'package:e_course_app/components/image_carousel.dart';
import 'package:e_course_app/components/video_grid.dart';
import 'package:e_course_app/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_course_app/components/image_carousel.dart';
import 'package:e_course_app/components/video_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_course_app/pages/watch_video.dart';
import 'package:e_course_app/services/database_service.dart';
import 'package:e_course_app/components/empty_content.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<QueryDocumentSnapshot<Object?>> videosList = [];
  bool? _isAdmin; 

  @override
  void initState() {
    super.initState();
    registerVideoDatabaseEvent();
  }

  void registerVideoDatabaseEvent() {
    DatabaseService.videoCollection().snapshots().listen((event) {
      setState(() {
        videosList = event.docs.toList();
      });
    }, onError: (error) {
        print('An error occured when fetching data');
      },
    );
  }

  Future<void> retrieveUserInfo() async {
    List<String>? userData = LocalStorageService.localStorage.getStringList('user');
    if (userData != null) _isAdmin = userData[1] == 'admin';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: null,
        title: const Text('E-Course App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const ImageCarousel(),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text('Course Videos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: videosList.isEmpty ? Column(children: const <Widget>[
                SizedBox(height: 10),
                EmptyContent(description: 'Stay tuned untuk video course nya, ya !')
              ]): 
              VideoGrid(videosList: videosList,
                onTap: (String videoId, Map<String, dynamic> videoData) { 
                  try {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WatchVideo(
                      youtubeVideoId: videoData['youtubeId'],
                      title: videoData['title'],
                      subject: videoData['subject'],
                    ))).then((_) {
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    });
                  } catch(e) {
                    print('Navigator error $e');
                  }
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
