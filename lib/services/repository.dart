// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class Repository {
  static final Dio dio = Dio();

  static Options headerParameters() {
    Options options = Options(
      contentType: Headers.jsonContentType,
      headers: {},
    );
    dio.interceptors.add(LogInterceptor());
    return options;
  }

  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8',
    };
  }

  initializeInterceptors() {
    dio.interceptors.add(LogInterceptor());
  }

  static getErrorResponse() {
    return {
      "status": {
        "type": "Error",
        "message": "Server Errors",
        "code": 200,
        "error": "true",
      },
    };
  }

  // ignore: non_constant_identifier_names
  static Future<dynamic> postApiService(dynamic endpoint, dynamic inputData) async {
    var formData = FormData.fromMap(inputData);
    try {
      Response response = await dio.post(
        endpoint, // Replace with your API endpoint
        data: formData,
      );
      print('Response: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response data: ${e.response!.data}');
        print('Error response headers: ${e.response!.headers}');
        return e;
      } else {
        print('Error sending request: $e');
        return e;
      }
    }
  }
}
