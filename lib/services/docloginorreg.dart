// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:healai/pages/doclogin.dart';
import 'package:healai/pages/docreg.dart';

class DocLoginOrReg extends StatefulWidget {
  const DocLoginOrReg({super.key});

  // This widget is the root of your application.
  @override
  State<DocLoginOrReg> createState() => _RestLoginOrRegState();
}

class _RestLoginOrRegState extends State<DocLoginOrReg> {
  bool ShowLoginPage = true;

  void togglePages() {
    setState(() {
      ShowLoginPage = !ShowLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ShowLoginPage) {
      return DocLogin(
        onTap: togglePages,
      );
    } else {
      return DocReg(
        onTap: togglePages,
      );
    }
  }
}
