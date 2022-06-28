import 'package:flutter/material.dart';

class AuthTopContent extends StatelessWidget {

  final String title;
  final String? description;

  const AuthTopContent({Key? key, this.title = 'E-Course App', this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        const SizedBox(height: 60),
        Image.asset('assets/images/book.png', width: 150),
        const SizedBox(height: 40),
        const Text('E-Course App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25
          )
        ),
        const SizedBox(height: 5),
        if (description != null) Text(description!),
        const SizedBox(height: 40)
      ],
    );
  }
  
}