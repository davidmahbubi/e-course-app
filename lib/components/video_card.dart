import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {

  final String imagePath;
  final String title;
  final String subject;

  const VideoCard({Key? key, required this.imagePath, required this.title, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          // borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Image.network(imagePath, height: 210, width: 160),
        ),
        const SizedBox(height: 13),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Flexible(
            child: Text(
              subject,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
