import 'package:e_course_app/components/video_card.dart';
import 'package:e_course_app/pages/video_form.dart';
import 'package:e_course_app/pages/watch_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoList extends StatefulWidget {
  const VideoList({Key? key}) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        title: const Text(
          'E-Course App',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Video yang Tersedia',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  childAspectRatio: 0.58,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  cacheExtent: 999999999,
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(10, (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => VideoForm(
                              pageTitle: 'Update Video',
                            ),
                          ),
                        );
                      },
                      child: const VideoCard(
                        imagePath: 'https://firebasestorage.googleapis.com/v0/b/e-course-app.appspot.com/o/thumbnails%2FggQYfoBRiW.jpg?alt=media',
                        title: 'ss',
                        subject: 'ssss',
                        ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => VideoForm(
                pageTitle: 'Tambah Video',
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
