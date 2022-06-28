import 'package:e_course_app/services/auth_service.dart';
import 'package:e_course_app/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Profile extends StatefulWidget {

  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String _displayName = '';
  String _email = '';

  @override
  initState() {
    super.initState();
    fetchProfileData();
  }

  void fetchProfileData() {
    List<String>? userData = LocalStorageService.localStorage.getStringList('user');
    setState(() {
      _displayName = userData![0];
      _email = userData[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget> [
              const SizedBox(height: 80), 
              SvgPicture.asset('assets/images/student.svg', width: 180),
              const SizedBox(height: 20),
              Text(_displayName, style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
              const SizedBox(height: 10),
              Text(_email),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {;
                  LocalStorageService.localStorage.remove('user');
                  await AuthService.signOut();
                  
                },
                child: const Text('Sign Out'),
              )
            ],
          ),
        ),
      ),
    );
  }
}