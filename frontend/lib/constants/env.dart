import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

// class ENVConfig {
//   static String get serverUrl {
//     if (kIsWeb) {
//       return 'http://localhost:8000'; // Web
//     } else if (Platform.isAndroid && !Platform.isIOS) {
//       return 'http://10.0.2.2:8000'; // Android emulator
//     } else if (Platform.isIOS) {
//       return 'http://localhost:8000'; // iOS simulator
//     } else {
//       return 'http://172.28.19.36:8000'; // Physical devices
//     }
//   }

//   static const String loginRoute = '/api/login';
//   // ... rest of your levels data ...
// }

class ENVConfig {
  static String get serverUrl {
    if (kIsWeb) {
      return 'http://localhost:8000'; // Web
    } else if (Platform.isAndroid && !Platform.isIOS) {
      return 'http://10.0.2.2:8000'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:8000'; // iOS simulator
    } else {
      return 'http://192.168.8.100:8000'; // Physical devices
    }
  }
  static const String loginRoute = '/api/login';
}