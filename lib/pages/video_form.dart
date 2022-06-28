import 'dart:io';
import 'package:e_course_app/enums/video_form_mode.dart';
import 'package:e_course_app/pages/admin_mode.dart';
import 'package:e_course_app/pages/watch_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_course_app/services/storage_service.dart';
import 'package:e_course_app/utils/helper.dart';
import 'package:e_course_app/services/database_service.dart';
import 'package:form_validator/form_validator.dart';

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
  final _formKey = GlobalKey<FormState>();

  String thumbName = '';
  File? localFile;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    if (widget.videoFormMode == VideoFormMode.update) {
      
      youtubeIdController.text = widget.videoData!['videoMeta']['youtubeId'];
      videoTitleController.text = widget.videoData!['videoMeta']['title'];
      subjectTitleController.text = widget.videoData!['videoMeta']['subject'];

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
            child: Form(
              key: _formKey,
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
                          widget.videoFormMode == VideoFormMode.update ? Image.network(widget.videoData!['videoMeta']['thumbnailUrl'], width: 200) : Image.asset('assets/images/picture.png', width: 200),
                          const SizedBox(height: 30),
                          const Text('Klik disini untuk menambah thumbnail')
                        ] : [
                          Image.file(localFile!, width: 200)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: youtubeIdController,
                    validator: ValidationBuilder(localeName: 'id').required().build(),
                    decoration: const InputDecoration(
                      label: Text('ID YouTube Video'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: videoTitleController,
                    validator: ValidationBuilder(localeName: 'id').required().build(),
                    decoration: const InputDecoration(
                      label: Text('Judul Video'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: subjectTitleController,
                    validator: ValidationBuilder(localeName: 'id').required().build(),
                    decoration: const InputDecoration(
                      label: Text('Mata Pelajaran'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _isLoading ? Center(child: CircularProgressIndicator()) : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (localFile != null) {
                            setState(() {
                              _isLoading = true;
                            });
                            bool storeStatus = await storeVideo();
                            setState(() {
                              _isLoading = false;
                            });
                            if (storeStatus) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Berhasil menambahkan data video baru')),
                              );
                              Navigator.pop(context);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gambar thumbnail belum diisi !') ));
                          }
                        }
                      },
                      child:  const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Text('Simpan'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (widget.videoFormMode == VideoFormMode.update)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 5),
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WatchVideo(
                                youtubeVideoId: widget.videoData!['videoMeta']['youtubeId'],
                                subject: widget.videoData!['videoMeta']['subject'],
                                title: widget.videoData!['videoMeta']['title'],
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
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 5),
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () async {
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Hapus Video ?'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: const <Widget> [
                                        Text('Video ini akan dihapus secara permanent! Pastikan anda juga menghapus file video dari dashbord YouTube'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget> [
                                    TextButton(child: const Text('Batal'), onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                    TextButton(child: const Text('Hapus'),
                                      onPressed: () {
                                        DatabaseService.deleteVideo(widget.videoData!['id']).then((_) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                    }),
                                  ],
                                );
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              child: Text('Hapus Video'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> uploadFiles(FilePickerResult? fpr) async {
    try {
      if (fpr != null) {
        if (mounted) {
          setState(() {
            localFile = File(fpr.files.single.path!);
          });
        }
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
