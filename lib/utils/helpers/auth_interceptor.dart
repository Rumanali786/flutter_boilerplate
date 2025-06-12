import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';

class AuthInterceptor implements InterceptorContract {
  String? token;

  // int? companyId;

  // ignore: use_setters_to_change_properties
  void setToken(String value) {
    token = value;
  }

  // // ignore: use_setters_to_change_properties
  // void setCompanyId(int value) {
  //   print("set company");
  //   companyId = value;
  // }

  void removeConfigValues() {
    token = null;
    // companyId = null;
  }

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers.addAll({
      // if (token != null) 'Authorization': 'Token $token',
      HttpHeaders.contentTypeHeader: request is MultipartRequest ? 'multipart/form-data' : 'application/json',
       HttpHeaders.acceptHeader: 'application/json',
    });
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async => true;

  @override
  Future<bool> shouldInterceptResponse() async => false;
}
