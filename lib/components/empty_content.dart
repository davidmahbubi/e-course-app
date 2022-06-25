import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyContent extends StatelessWidget {

  final String title;
  final String? description;

  const EmptyContent({super.key, this.title = 'Tidak Ada Konten', this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget> [
          SvgPicture.asset('assets/images/empty.svg', width: 300),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          )),
          const SizedBox(height: 10),
          if (description != null) Text(description!),
        ],
      )
    );
  }
}