import 'dart:async';

import 'package:chat/core/app_keys.dart';
import 'package:chat/presentation/auth/auth_page.dart';
import 'package:chat/presentation/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences preferences;
  late String auth;
  late String id;
  getIsAuth() async {
    preferences = await SharedPreferences.getInstance();
    auth = preferences.get(AppKeys.authKey).toString();
    id = preferences.get(AppKeys.userId).toString();
    setState(() {});
  }

  @override
  void initState() {
    getIsAuth();
    Timer(const Duration(milliseconds: 1700), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        if (auth == "yes") {
          return MainPageScreen(
            id: id,
          );
        } else {
          return const AuthScreen();
        }
      }), (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Chat"),
      ),
    );
  }
}
