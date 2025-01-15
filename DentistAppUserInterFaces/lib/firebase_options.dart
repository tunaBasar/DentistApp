import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web platformu için DefaultFirebaseOptions yapılandırılmamış.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions, ${defaultTargetPlatform.toString()} platformu için yapılandırılmamış.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZ6r-zDN7S_HAjMEpFN17OgRp_m9OIMB4',
    appId: '1:566815215135:android:488699a0f1899f89de4f2a',
    messagingSenderId: '566815215135',
    projectId: 'dentist-app-9f43a',
  );
}
