import 'package:e_course_app/components/video_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_course_app/enums/video_form_mode.dart';
import 'package:e_course_app/components/empty_content.dart';
import 'package:e_course_app/pages/video_form.dart';
import 'package:e_course_app/services/database_service.dart';

class AdminMode extends StatefulWidget {
  const AdminMode({Key? key}) : super(key: key);

  @override
  State<AdminMode> createState() => _AdminModeState();
}

class _AdminModeState extends State<AdminMode> {

  List<QueryDocumentSnapshot<Object?>> videosList = [];

  @override
  void initState() {
    super.initState();
    registerVideoDatabaseEvent();
  }

  void registerVideoDatabaseEvent() {
    DatabaseService.videoCollection().snapshots().listen(
      (event) {
        if (mounted) {
          setState(() {
            videosList = event.docs.toList();
          });
        }
      },
      onError: (error) {
        print('An error occured when fetching data');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                ) : VideoGrid(videosList: videosList, onTap: (String videoId, Map<String, dynamic> videoData) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) => VideoForm(pageTitle: 'Update Video', videoFormMode: VideoFormMode.update, videoData: {
                          'id': videoId,
                          'videoMeta': videoData,
                        })),
                      );
                    },
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
