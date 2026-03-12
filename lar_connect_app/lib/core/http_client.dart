import 'package:dio/dio.dart';
import 'app_config.dart';

//http_client.dart = “cliente HTTP que usa essa URL”.

final dio = Dio(
  BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ),
);