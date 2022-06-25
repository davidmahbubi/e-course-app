import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_course_app/enums/video_form_mode.dart';
import 'package:e_course_app/components/empty_content.dart';
import 'package:e_course_app/components/video_card.dart';
import 'package:e_course_app/pages/video_form.dart';
import 'package:e_course_app/services/database_service.dart';

class VideoList extends StatefulWidget {
  const VideoList({Key? key}) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {

  List<QueryDocumentSnapshot<Object?>> videosList = [];

  @override
  void initState() {
    super.initState();
    registerVideoDatabaseEvent();
  }

  void registerVideoDatabaseEvent() {
    DatabaseService.videoCollection().snapshots().listen(
      (event) {
        setState(() {
          videosList = event.docs.toList();
        });
      },
      onError: (error) {
        print('An error occured when fetching data');
      },
    );
  }

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
              const Text('Video yang Tersedia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              Expanded(
                child: videosList.isEmpty ? Column(
                  children: const <Widget> [
                    SizedBox(height: 10),
                    EmptyContent(description: 'Klik tombol + untuk menambahkan video baru')
                  ],
                ) : GridView.count(
                  childAspectRatio: 0.58,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  cacheExtent: 9999,
                  physics: const BouncingScrollPhysics(),
                  children: videosList.map((QueryDocumentSnapshot<Object?> data) {
                    Map<String, dynamic> videoData = data.data() as Map<String, dynamic>;
                    return InkWell(
                      onTap:  () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VideoForm(pageTitle: 'Update Video', videoFormMode: VideoFormMode.update, videoData: {
                          'id': data.id,
                          'videoMeta': videoData,
                        })));
                      },
                      child: VideoCard(
                        imagePath: videoData['thumbnailUrl'],
                        title: videoData['title'],
                        subject: videoData['subject'],
                      ),
                    );
                  }).toList(),
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
                videoFormMode: VideoFormMode.create,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
