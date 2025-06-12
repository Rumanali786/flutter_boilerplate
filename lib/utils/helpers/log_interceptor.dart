import 'dart:developer';

import 'package:http_interceptor/http_interceptor.dart';

class LogInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    log('\n----- Request -----');
    log('\n');
    log('${request.method}: ${request.url}');
    log('Headers: ${request.headers}');
    if (request is MultipartRequest) {
      log('Body: ${request.fields}');
    } else {
      log('Body: ${(request as Request).body}');
    }
    log('\n');
    log('-------------------');
    log('\n');
    // TODO: undo below changes
    // Flogger.i('\n----- Request -----');
    // Flogger.i('\n');
    // Flogger.i('${request.method}: ${request.url}');
    // Flogger.i('Headers: ${request.headers}');
    // if (request is MultipartRequest) {
    //   Flogger.i('Body: ${request.fields}');
    // } else {
    //   Flogger.i('Body: ${(request as Request).body}');
    // }
    // Flogger.i('\n');
    // Flogger.i('-------------------');
    // Flogger.i('\n');

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    log('\n----- Response -----');
    log('\n');
    log('Status Code: ${response.statusCode}');

    if (response is! StreamedResponse) {
      log('Response Body: ${(response as Response).body}');
    }
    log('\n');
    log('--------------------');
    log('\n');



    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async => true;

  @override
  Future<bool> shouldInterceptResponse() async => true;
}
