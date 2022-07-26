import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_course_app/components/video_card.dart';
import 'package:flutter/material.dart';

class VideoGrid extends StatelessWidget {

  final List<QueryDocumentSnapshot<Object?>> videosList;
  final Function(String videoId, Map<String, dynamic> videoData) onTap;

  const VideoGrid({super.key, required this.videosList, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.65,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: videosList.map((QueryDocumentSnapshot<Object?> data) {
        Map<String, dynamic> videoData = data.data() as Map<String, dynamic>;
        return InkWell(
          onTap: () {
            onTap(data.id, videoData);
          },
          child: VideoCard(
            imagePath: videoData['thumbnailUrl'],
            title: videoData['title'],
            subject: videoData['subject'],
          ),
        );
      }).toList(),
    );
  }
}