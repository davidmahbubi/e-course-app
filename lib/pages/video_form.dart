import 'dart:io';
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

  VideoForm({Key? key, required this.pageTitle}) : super(key: key);

  @override
  State<VideoForm> createState() => _VideoFormState();
}

class _VideoFormState extends State<VideoForm> {

  TextEditingController youtubeIdController = TextEditingController();
  TextEditingController videoTitleController = TextEditingController();
  TextEditingController subjectTitleController = TextEditingController();

  String thumbName = '';

  @override
  Widget build(BuildContext context) {
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
                    child: Image.asset('assets/images/example_banner_video.jpg', height: 250)
                  ),
                ),
                const SizedBox(height: 40),
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
                      print('Data stored');
                      print(storeStatus);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text('Berhasil menambahkan data video baru')),
                      // );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Text('Simpan'),
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
        File thumbsFile = File(fpr.files.single.path!);
        String fileName = randomizeFileName(thumbsFile);
        widget.thumbsRef.child(fileName).putFile(thumbsFile);
        return fileName;
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
      }).then((value) {
        print('Suksesss');
        return true;
      });
    } on Exception catch(e) {
      return false;
    }
  }
}
