import 'dart:async';

import 'package:chat/core/app_keys.dart';
import 'package:chat/presentation/auth/auth_page.dart';
import 'package:chat/presentation/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  timer() async {
    Timer(const Duration(milliseconds: 2500), () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        if (preferences.get(AppKeys.authKey).toString() == "yes") {
          return MainPageScreen(
            id: preferences.get(AppKeys.userId).toString(),
          );
        } else {
          return const AuthScreen();
        }
      }), (route) => false);
    });
  }

  @override
  void initState() {
    timer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset('assets/image/chat.json'),
      ),
    );
  }
}
