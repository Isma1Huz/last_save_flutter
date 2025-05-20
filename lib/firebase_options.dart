// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDHtnywQqNpUk-fi7jNUfvIk5Nz4GLgOnY',
    appId: '1:75133745727:android:66a3daf09e13d56e2bd68a',
    messagingSenderId: '75133745727',
    projectId: 'last-save',
    storageBucket: 'last-save.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbPtRRB7Pix3ugoJlHevhl3DaZrGFh7BA',
    appId: '1:75133745727:ios:3d6ab42b1fbdf4e82bd68a',
    messagingSenderId: '75133745727',
    projectId: 'last-save',
    storageBucket: 'last-save.firebasestorage.app',
    iosClientId: '75133745727-ej1gde8clcusdlicp584o6a7h8to2ttk.apps.googleusercontent.com',
    iosBundleId: 'com.example.lastSave',
  );
}
