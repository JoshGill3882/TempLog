import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/authentication/landing_page/pages/splash_screen.dart';
import 'package:templog/src/theme/common_theme.dart';

Future<void> main() async {
  runApp(MaterialApp(title: "TempLog", theme: CommonTheme.themeData, home: const SplashScreen()));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
