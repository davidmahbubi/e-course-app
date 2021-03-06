import 'package:e_course_app/pages/wrapper.dart';
import 'package:e_course_app/services/auth_service.dart';
import 'package:e_course_app/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorageService.initLocalStorage();
  runApp(const ECourseApp());
}

class ECourseApp extends StatelessWidget {
  const ECourseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(const <DeviceOrientation> [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // status bar color
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: StreamProvider.value(
        value: AuthService.firebaseUserStream,
        initialData: null,
        child: const Wrapper(),
      ),
    );
  }
}
