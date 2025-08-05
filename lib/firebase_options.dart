import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyC9EUDqLsbjQ0p9OJ8ZRH9aArW_Utxv3_A",
    authDomain: "sandys-snacks-app.firebaseapp.com",
    projectId: "sandys-snacks-app",
    storageBucket: "sandys-snacks-app.firebasestorage.app",
    messagingSenderId: "314035808168",
    appId: "1:314035808168:web:13a183a848e76d8c301f9d",
    measurementId: "G-3WTGSE0FDF",
  );
}
