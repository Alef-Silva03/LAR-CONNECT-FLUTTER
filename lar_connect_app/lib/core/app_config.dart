import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _apiFromEnv = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_apiFromEnv.isNotEmpty) {
      return _apiFromEnv;
    }

    if (kIsWeb) {
      return 'http://localhost:8080';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8080';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return 'http://localhost:8080';
    }
  }
}