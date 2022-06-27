import 'package:e_course_app/pages/home.dart';
import 'package:e_course_app/pages/profile.dart';
import 'package:e_course_app/pages/video_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getStringList('user')![1] == 'admin';
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pagesList = <Widget> [Home(), Profile()];
    if (_isAdmin) pagesList.add(const VideoList());

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          if (_isAdmin) BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin Mode'),
        ],
      ),
    );
  }
}