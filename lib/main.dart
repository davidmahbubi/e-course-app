import 'package:e_course_app/pages/home.dart';
import 'package:flutter/material.dart';

void main(List<String> args) => runApp(const ECourseApp());

class ECourseApp extends StatelessWidget {
  const ECourseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
