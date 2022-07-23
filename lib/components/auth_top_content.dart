import 'package:flutter/material.dart';

class AuthTopContent extends StatelessWidget {

  final String title;
  final String? description;

  const AuthTopContent({Key? key, this.title = 'SayuWiwit Edu', this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        const SizedBox(height: 60),
        Image.asset('assets/images/sayuwiwit_edu.png', width: 250),
        const SizedBox(height: 15),
        // const Text('Admin Mode',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 25
        //   )
        // ),
        const SizedBox(height: 10),
        if (description != null) Text(description!, textAlign: TextAlign.center),
        const SizedBox(height: 30)
      ],
    );
  }
  
}