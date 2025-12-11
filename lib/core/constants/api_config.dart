import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class ApiConfig {
  static String get baseUrl {
    // For web, use localhost
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    
    // For Android emulator, use 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }

    // For iOS, macOS, Windows, Linux, use localhost
    return 'http://localhost:3000';
  }
}
