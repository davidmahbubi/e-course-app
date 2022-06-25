import 'dart:io';
import 'package:e_course_app/enums/video_form_mode.dart';
import 'package:e_course_app/pages/watch_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_course_app/services/storage_service.dart';
import 'package:e_course_app/utils/helper.dart';
import 'package:e_course_app/services/database_service.dart';

class VideoForm extends StatefulWidget {
  final String pageTitle;
  final Reference thumbsRef = StorageService.getRef('/thumbnails');
  final VideoFormMode videoFormMode;
  final Map<String, dynamic>? videoData;

  VideoForm({Key? key, required this.pageTitle, required this.videoFormMode, this.videoData}) : super(key: key);

  @override
  State<VideoForm> createState() => _VideoFormState();
}

class _VideoFormState extends State<VideoForm> {

  TextEditingController youtubeIdController = TextEditingController();
  TextEditingController videoTitleController = TextEditingController();
  TextEditingController subjectTitleController = TextEditingController();

  String thumbName = '';
  File? localFile;

  @override
  Widget build(BuildContext context) {

    if (widget.videoFormMode == VideoFormMode.update) {
      print(widget.videoData);
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        title: Text(
          widget.pageTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: InkWell(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles();
                      thumbName = await uploadFiles(result) ?? 'default-thumbnail';
                    },
                    child: Column(
                      children: localFile == null ? [
                        const SizedBox(height: 20),
                        Image.asset('assets/images/picture.png', width: 200),
                        const SizedBox(height: 30),
                        const Text('Klik disini untuk menambah thumbnail')
                      ] : [
                        Image.file(localFile!)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: youtubeIdController,
                  decoration: const InputDecoration(
                    label: Text('ID YouTube Video'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: videoTitleController,
                  decoration: const InputDecoration(
                    label: Text('Judul Video'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: subjectTitleController,
                  decoration: const InputDecoration(
                    label: Text('Mata Pelajaran'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool storeStatus = await storeVideo();
                      if (storeStatus) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Berhasil menambahkan data video baru')),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Text('Simpan'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (widget.videoFormMode == VideoFormMode.update)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WatchVideo(
                        youtubeVideoId: widget.videoData!['videoMeta']['youtubeId'],
                      ))).then((_) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                        SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.edgeToEdge,
                        );
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Text('Preview Video'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> uploadFiles(FilePickerResult? fpr) async {
    try {
      if (fpr != null) {
        setState(() {
          localFile = File(fpr.files.single.path!);
        });
        if (localFile != null) {
          String fileName = randomizeFileName(localFile!);
          print('FILE NAME = $fileName');
          widget.thumbsRef.child(fileName).putFile(localFile!);
          return fileName;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      print('Error uploading file');
      return null;
    }
  }

  Future<bool> storeVideo() async {
    try {
      return DatabaseService.videoCollection().add({
        'youtubeId': youtubeIdController.text,
        'title': videoTitleController.text,
        'subject': subjectTitleController.text,
        'tumbnailName': thumbName,
        'thumbnailUrl': await fetchFirebaseImage(thumbName),
      }).then((value) {
        print('Suksesss');
        return true;
      });
    } on Exception catch(e) {
      return false;
    }
  }

  Future<String> fetchFirebaseImage(String imageName) async {
    Reference ref = StorageService.getRef('thumbnails').child(imageName);
    String url = await ref.getDownloadURL();
    return url;
  }
}
