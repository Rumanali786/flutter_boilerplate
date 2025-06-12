import 'package:flutter/foundation.dart';

/// Configure REST API properties to be used later on
/// throughout API calls
///
/// Though for a specific use case these can also be
/// overridden in API call functions it [getRequest()]
/// and [postRequest()]
class APIConfig {
  /// base url for the project
  // static String baseUrl = 'http://16.170.12.34/api/v1';
  static String baseUrl = 'https://admin.denadlakoranen.se/api/v1';
  // static String domain = 'http://16.170.12.34/';
  static String domain = 'https://admin.denadlakoranen.se/';
  static String awsBaseUrl = 'https://dak-quran-audios.s3.eu-north-1.amazonaws.com/';
  static String awsVideoBaseUrl = 'https://dak-quran-podcast.s3.eu-north-1.amazonaws.com/';

  /// header for the project
  static Map<String, String>? header;

  /// duration for timeout request
  static Duration responseTimeOut = const Duration(seconds: kDebugMode ? 20 : 5);
}
