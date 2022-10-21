import 'package:flutter/material.dart';
import 'package:todoapp/auth/authform.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authentication Page"),
      ),
      body: const AuthForm(),
    );
  }
}
