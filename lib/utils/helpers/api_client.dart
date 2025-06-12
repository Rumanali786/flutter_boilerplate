import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart' as getx;
import 'package:http_interceptor/http_interceptor.dart';

import 'api_config.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'exceptions.dart';
import 'log_interceptor.dart';

/// API Client to interact with any REST API
class APIClient extends getx.GetxController {
  APIClient({
    required InterceptorContract authInterceptor,
    InterceptedClient? client,
    InterceptorContract? errorInterceptor,
    InterceptorContract? logInterceptor,
  })  : _authInterceptor = authInterceptor as AuthInterceptor,
        _client = client ??
            InterceptedClient.build(
              interceptors: [
                authInterceptor,
                errorInterceptor ?? ErrorInterceptor(),
                logInterceptor ?? LogInterceptor(),
              ],
            );

  final InterceptedClient _client;
  final AuthInterceptor _authInterceptor;

  /// Used to initiate a [get] request
  ///
  /// The [handle] is end point that will be attached to the [baseUrl]
  /// which either can be provided as a whole using the [APIConfig]
  /// setting or can be overidden as it is given as an option parameter
  /// in the function.
  ///
  /// Same thing applies for the [header] parameter
  Future<dynamic> get({
    required String handle,
    String? baseUrl,
    Map<String, String>? header,
    Duration? timeOut,
  }) async {
    final token = getAuthToken();
    final headers = header ??
        {
          if (token != null) 'Authorization': 'Bearer $token',
        };
    return _request(
      call: (uri) async => _client.get(uri, headers: headers),
      baseUrl: baseUrl,
      handle: handle,
      timeOut: timeOut,
    );
  }

  Future<dynamic> readBytes({
    String? baseUrl,
    Map<String, String>? header,
    Duration? timeOut,
  }) async {
    final d = await _readBytes(
      call: (uri) async => _client.readBytes(
        uri,
      ),
      baseUrl: baseUrl,
      timeOut: timeOut,
    );
    return d;
  }

  /// Used to initiate a [post] request
  ///
  /// Use the [body] parameter to send the json data to the service
  ///
  /// The [handle] is end point that will be attached to the [baseUrl]
  /// which either can be provided as a whole using the [APIConfig]
  /// setting or can be overidden as it is given as an option parameter
  /// in the function.
  ///
  /// Same thing applies for the [header] parameter
  Future<dynamic> post({
    required String handle,
    dynamic body,
    String? baseUrl,
    Map<String, String>? header,
    Duration? timeOut,
  }) async {
    final token = getAuthToken();
    final headers = header ??
        {
          if (token != null) 'Authorization': 'Bearer $token',
        };
    return _request(
      call: (uri) async => _client.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      ),
      baseUrl: baseUrl,
      handle: handle,
      timeOut: timeOut,
    );
  }

  /// Used to initiate a [put] request
  ///
  /// Use the [body] parameter to send the json data to the service
  ///
  /// The [handle] is end point that will be attached to the [baseUrl]
  /// which either can be provided as a whole using the [APIConfig]
  /// setting or can be overidden as it is given as an option parameter
  /// in the function.
  ///
  /// Same thing applies for the [header] parameter
  Future<dynamic> put({
    required String handle,
    dynamic body,
    String? baseUrl,
    Map<String, String>? header,
    Duration? timeOut,
  }) async {
    final token = getAuthToken();
    final headers = header ??
        {
          if (token != null) 'Authorization': 'Bearer $token',
        };
    return _request(
      call: (uri) async => _client.put(
        uri,
        headers: headers,
        body: jsonEncode(body),
      ),
      baseUrl: baseUrl,
      handle: handle,
      timeOut: timeOut,
    );
  }

  /// Used to initiate a [patch] request
  ///
  /// Use the [body] parameter to send the json data to the service
  ///
  /// The [handle] is end point that will be attached to the [baseUrl]
  /// which either can be provided as a whole using the [APIConfig]
  /// setting or can be overidden as it is given as an option parameter
  /// in the function.
  ///
  /// Same thing applies for the [header] parameter
  Future<dynamic> patch({
    required String handle,
    dynamic body,
    String? baseUrl,
    Map<String, String>? header,
    Duration? timeOut,
  }) async {
    final token = getAuthToken();
    final headers = header ??
        {
          if (token != null) 'Authorization': 'Bearer $token',
        };
    return _request(
      call: (uri) async => _client.patch(
        uri,
        headers: headers,
        body: jsonEncode(body),
      ),
      baseUrl: baseUrl,
      handle: handle,
      timeOut: timeOut,
    );
  }

  /// Used to initiate a [delete] request
  ///
  /// Use the [body] parameter to send the json data to the service
  ///
  /// The [handle] is end point that will be attached to the [baseUrl]
  /// which either can be provided as a whole using the [APIConfig]
  /// setting or can be overidden as it is given as an option parameter
  /// in the function.
  ///
  /// Same thing applies for the [header] parameter
  Future<dynamic> delete({
    required String handle,
    dynamic body,
    String? baseUrl,
    Map<String, String>? header,
    Duration? timeOut,
  }) async {
    final token = getAuthToken();
    final headers = header ??
        {
          if (token != null) 'Authorization': 'Bearer $token',
        };
    return _request(
      call: (uri) async => _client.delete(
        uri,
        headers: headers,
        body: jsonEncode(body),
      ),
      baseUrl: baseUrl,
      handle: handle,
      timeOut: timeOut,
    );
  }

  Future<dynamic> postMultipart({
    required String handle,
    required String fieldName,
    required List<dynamic> files,
    Map<String, String>? body,
    String? baseUrl,
    String? method,
    Map<String, String>? header,
    Duration? timeOut,
  }) async {
    // final timeout to be used with request
    final responseTimeout = timeOut ?? APIConfig.responseTimeOut;
    final url = (baseUrl ?? APIConfig.baseUrl) + handle;

    // uri to be passed to request
    final uri = Uri.parse(url);
    final request = MultipartRequest(method ?? HttpMethod.POST.asString, uri);

    final token = getAuthToken();
    final headers = header ??
        {
          if (token != null) 'Authorization': 'Bearer $token',
        };

    request.headers.addAll(headers);

    if (body != null) request.fields.addAll(body);

    for (final element in files) {
      final newFile =
          await MultipartFile.fromPath(fieldName, element['path'].toString(), filename: element['name'].toString());
      request.files.add(newFile);
    }

    final multipartResponse = await _client.send(request).timeout(
          responseTimeout,
        );
    final response = await Response.fromStream(multipartResponse);
    log('---Multipart Response Body----');
    log(response.body);
    log('-----Status code-----');
    log(response.statusCode.toString());
    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    final message = responseBody['message'] as String?;

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseBody;
      case 401:
      case 422:
        // final authRepo = Get.find<AuthRepositoryImpl>();
        // await authRepo.signOut();
        throw UnauthorizedException(message?.tr);
      case 403:
        throw UnauthorizedException(message?.tr);
      case 404:
        throw NotFoundException(message?.tr);
      case 408:
        throw const RequestTimeoutException();
      case 400:
      case 500:
      default:
        throw const DefaultException();

      // case 200:
      // case 201:
      //   return responseBody;
      // case 401:
      // case 403:
      //   throw UnauthorizedException(message);
      // case 404:
      //   throw NotFoundException(message);
      // case 408:
      //   throw const RequestTimeoutException();
      // case 400:
      // case 500:
      // default:
      //   throw const DefaultException();
    }
  }

  Future<dynamic> _request({
    required Future<Response> Function(Uri uri) call,
    required String handle,
    String? baseUrl,
    Duration? timeOut,
  }) async {
    // final url to which call will be made
    final url = (baseUrl ?? APIConfig.baseUrl) + handle;
    // uri to be passed to request
    final uri = Uri.parse(url);

    // final timeout to be used with request
    final responseTimeout = timeOut ?? APIConfig.responseTimeOut;

    try {
      final response = await call(uri).timeout(responseTimeout);
      return jsonDecode(response.body);
    } on SocketException {
      throw const NoInternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    }
  }

  Future<Uint8List> _readBytes({
    required Future<Uint8List> Function(Uri uri) call,
    String? baseUrl,
    Duration? timeOut,
  }) async {
    // final url to which call will be made
    final url = baseUrl;

    // uri to be passed to request
    final uri = Uri.parse(url!);
    // final timeout to be used with request
    try {
      final response = await call(uri);
      return response;
    } on SocketException {
      throw const NoInternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    }
  }

  void setAuthToken(String value) {
    _authInterceptor.setToken(value);
  }

  // void setCompanyId(int value) {
  //   _authInterceptor.setCompanyId(value);
  // }

  void removeConfigValues() {
    _authInterceptor.removeConfigValues();
  }

  String? getAuthToken() {
    return _authInterceptor.token;
  }

// int? getCompanyId() {
//   // return _authInterceptor.companyId;
// }
}
