import 'package:flutter/material.dart';
import 'package:healai/pages/userlogin.dart';
import 'package:healai/pages/registerpage.dart';

class LoginOrReg extends StatefulWidget {
  const LoginOrReg({super.key});

  // This widget is the root of your application.
  @override
  State<LoginOrReg> createState() => _LoginOrRegState();
}

class _LoginOrRegState extends State<LoginOrReg> {
  bool ShowLoginPage = true;

  void togglePages() {
    setState(() {
      ShowLoginPage = !ShowLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ShowLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
