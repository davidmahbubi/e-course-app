import 'package:e_course_app/components/auth_top_content.dart';
import 'package:e_course_app/pages/main_page.dart';
import 'package:e_course_app/pages/sign_in.dart';
import 'package:e_course_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';

class SignUp extends StatefulWidget {

  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });
    await AuthService.signUpWithEmailPassword(_nameController.text, _emailController.text, _passwordController.text);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
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
                const AuthTopContent(description: 'Registrasi akun pelajar'),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget> [
                        TextFormField(
                          controller: _nameController,
                          validator: ValidationBuilder(localeName: 'id').required().build(),
                          decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Nama')),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: ValidationBuilder(localeName: 'id').required().email().build(),
                          decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('E-Mail')),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          validator: ValidationBuilder(localeName: 'id').required().minLength(8).build(),
                          decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Password')),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          obscureText: true,
                          controller: _passwordConfirmationController,
                          validator: (value) => value != _passwordController.text ? 'Konfirmasi password harus sama dengan password' : null,
                          decoration: const InputDecoration(border: OutlineInputBorder(), label: Text('Konfirmasi Password')),
                        ),
                        const SizedBox(height: 17),
                        _isLoading ? const CircularProgressIndicator() : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _register();
                                // ignore: use_build_context_synchronously
                                // Navigator.pop(context);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 17),
                              child: Text('Daftar'),
                            )
                          )
                        ),
                        const SizedBox(height: 17),
                        RichText(text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          children: <TextSpan> [
                            const TextSpan(text: 'Sudah punya akun ? '),
                            TextSpan(
                              text: 'Masuk',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.pop(context);
                              }
                            )
                          ]
                        )),
                        const SizedBox(height: 20),
                      ],
                    ),
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