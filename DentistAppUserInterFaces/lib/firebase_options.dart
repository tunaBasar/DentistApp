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
    apiKey: 'AIzaSyArgwBzCWsfQBBLM2-z1hIOPht4pzfnTtQ',
    appId: '1:337226006598:android:84606f7f0a2664aeda8a47',
    messagingSenderId: '337226006598',
    projectId: 'dentistapp-bd20c',
  );
}
