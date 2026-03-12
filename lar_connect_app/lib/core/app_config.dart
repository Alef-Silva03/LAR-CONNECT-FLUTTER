import 'package:flutter/foundation.dart';

//app_config.dart = “serve para centralizar e decidir automaticamente a URL da API que o app Flutter vai usar, dependendo do ambiente/plataforma”.

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