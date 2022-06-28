import 'dart:async';
import 'package:e_course_app/pages/home.dart';
import 'package:e_course_app/pages/profile.dart';
import 'package:e_course_app/pages/admin_mode.dart';
import 'package:e_course_app/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {


  const MainPage({ Key? key }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _index = 0;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchAdminPrevilege();
  }

  Future<void> fetchAdminPrevilege() async {
    setState(() {
      final userData = LocalStorageService.localStorage.getStringList('user');
      print(userData);
      _isAdmin = userData != null ? userData[1] == 'admin' : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pagesList = <Widget> [const Home(), const Profile()];
    if (_isAdmin) pagesList.add(const AdminMode());

    return Scaffold(
      body: pagesList[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int tappedIndex) {
          setState(() {
            _index = tappedIndex;
          });
        },
        items: <BottomNavigationBarItem> [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          if (_isAdmin) const BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin Mode'),
        ],
      ),
    );
  }
}