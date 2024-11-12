import 'package:flutter/material.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/authentication/landing_page/pages/landing_page.dart';
import 'package:templog/src/util/services/shared_preference_service.dart';

class SignOutService {
  static signOut(BuildContext context) {
    SharedPreferenceService sharedPreferenceService = SharedPreferenceService();
    sharedPreferenceService.clearSharedPreference();
    DefaultFirebaseOptions.auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPage()));
  }
}