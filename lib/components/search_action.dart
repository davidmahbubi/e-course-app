import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:e_course_app/utils/helper.dart';

class SearchAction extends StatelessWidget {

  final List<QueryDocumentSnapshot<Object?>> videosList;
  final Function(Map<String, dynamic> selectedVideo) onTap;

  const SearchAction({super.key, required this.videosList, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showSearch(
        context: context,
        delegate: SearchPage<Map<String, dynamic>>(
          barTheme: ThemeData(
            primarySwatch: generateWhiteSwatch(),
          ),
          builder: (Map<String, dynamic> val) => InkWell(
            onTap: () {
              onTap(val);
            },
            child: ListTile(
              title: Text(val['title']),
              subtitle: Text(val['subject']),
            ),
          ),
          suggestion: const Center(
            child: Text('Ketik judul video / mata pelajaran'),
          ),
          failure: const Center(
            child: Text('Tidak ada video yang cocok dengan pencarian ini'),
          ),
          filter: (Map<String, dynamic> val) => [
            val['title'],
            val['subject']
          ],
          items: videosList.map((QueryDocumentSnapshot<Object?> video) {
            Map<String, dynamic> videoData = video.data() as Map<String, dynamic>;
            videoData['vidId'] = video.id;
            return videoData;
          }).toList(),
        )
      ),
      icon: const Icon(Icons.search, color: Colors.black)
    );
  }
}