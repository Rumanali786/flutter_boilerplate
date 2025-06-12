import 'dart:convert';

import 'package:get/get.dart' as getx;
import 'package:http_interceptor/http_interceptor.dart';
import 'exceptions.dart';

class ErrorInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    return request;
  }



  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
     if (response is! StreamedResponse) {
      String? message;
      if(response.headers.containsValue('application/json')){
         final body =
        jsonDecode((response as Response).body) as Map<String, dynamic>;
          message = body['message'] as String?;
      }
        switch (response.statusCode) {
        case 200:
        case 201:
          return response;
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
      }
    } else {
      return response;
    }
  }

  @override
  Future<bool> shouldInterceptRequest() async => false;

  @override
  Future<bool> shouldInterceptResponse() async => true;
}
