
// ignore_for_file: prefer_const_constructors

import 'package:firebse_login/Screens/sign_up_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SignUpPage(),
    );
  }
}