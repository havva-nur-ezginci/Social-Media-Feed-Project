// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAZE8PkCrLOrGv8ozF2AmKfjp3WJbckRqU',
    appId: '1:915050554022:web:fc3e2eeeee7bf60ec10a67',
    messagingSenderId: '915050554022',
    projectId: 'social-media-feed-2c257',
    authDomain: 'social-media-feed-2c257.firebaseapp.com',
    storageBucket: 'social-media-feed-2c257.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZnjOdb087wKA29OqvU1nr6DiJ_Qknbpk',
    appId: '1:915050554022:android:b46c649610c77f76c10a67',
    messagingSenderId: '915050554022',
    projectId: 'social-media-feed-2c257',
    storageBucket: 'social-media-feed-2c257.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6KgrtLC9P7JVCOONFXqROe1g9JIHymwk',
    appId: '1:915050554022:ios:8026a09b9d291a11c10a67',
    messagingSenderId: '915050554022',
    projectId: 'social-media-feed-2c257',
    storageBucket: 'social-media-feed-2c257.appspot.com',
    iosBundleId: 'com.example.socialMediaFeed',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6KgrtLC9P7JVCOONFXqROe1g9JIHymwk',
    appId: '1:915050554022:ios:8026a09b9d291a11c10a67',
    messagingSenderId: '915050554022',
    projectId: 'social-media-feed-2c257',
    storageBucket: 'social-media-feed-2c257.appspot.com',
    iosBundleId: 'com.example.socialMediaFeed',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAZE8PkCrLOrGv8ozF2AmKfjp3WJbckRqU',
    appId: '1:915050554022:web:1b5bc2d37e9fbc3cc10a67',
    messagingSenderId: '915050554022',
    projectId: 'social-media-feed-2c257',
    authDomain: 'social-media-feed-2c257.firebaseapp.com',
    storageBucket: 'social-media-feed-2c257.appspot.com',
  );
}
