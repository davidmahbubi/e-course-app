import 'package:e_course_app/components/auth_top_content.dart';
import 'package:e_course_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget {

  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool?> _login() async {
    setState(() {
      _isLoading = true;
    });
    User? userData = await AuthService.signinWithEmailPassword(_emailController.text, _passwordController.text);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    return userData != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget> [
                const AuthTopContent(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget> [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('E-Mail'),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Password'),
                        ),
                      ),
                      const SizedBox(height: 17),
                      _isLoading ? CircularProgressIndicator() : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool? isLoginSuccess = await _login();
                            if (isLoginSuccess == null || !isLoginSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Username / Password anda salah ! silahkan cek kembali !'))
                              );
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 17),
                            child: Text('Masuk'),
                          )
                        )
                      ),
                      const SizedBox(height: 17),
                      RichText(text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        children: <TextSpan> [
                          const TextSpan(text: 'Belum punya akun ? '),
                          TextSpan(
                            text: 'Login',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              print('Clicked');
                            }
                          )
                        ]
                      )),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}