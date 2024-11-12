import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'FIREBASE API KEY',
    appId: 'FIREBASE APP ID',
    messagingSenderId: 'FIREBASE MESSAGING SENDER ID',
    projectId: 'FIREBASE PROJECT ID',
    storageBucket: 'FIREBASE STORAGE BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'FIREBASE API KEY',
    appId: 'FIREBASE APP ID',
    messagingSenderId: 'FIREBASE MESSAGING SENDER ID',
    projectId: 'FIREBASE PROJECT ID',
    storageBucket: 'FIREBASE STORAGE BUCKET',
  );

  static final auth = FirebaseAuth.instance;
  static final database = FirebaseFirestore.instance;
  static final functions = FirebaseFunctions.instance;
  static final storage = FirebaseStorage.instance;
}
