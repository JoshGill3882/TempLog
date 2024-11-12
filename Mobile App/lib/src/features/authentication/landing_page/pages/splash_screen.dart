import 'dart:async';

import 'package:flutter/material.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/authentication/landing_page/pages/landing_page.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/theme/common_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ super.key });

  @override
  State<StatefulWidget> createState() =>_SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CommonTheme.deepPurpleColor,
    );
  }

  void startTimer() {
    Timer(const Duration(seconds: 1), () {
      if (DefaultFirebaseOptions.auth.currentUser != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPage()));
      }
    });
  }
}