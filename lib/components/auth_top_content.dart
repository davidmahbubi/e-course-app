import 'package:flutter/material.dart';

class AuthTopContent extends StatelessWidget {
  const AuthTopContent({Key? key}) : super(key: key);

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
        const Text('Silahkan masuk untuk melanjutkan'),
        const SizedBox(height: 40)
      ],
    );
  }
  
}