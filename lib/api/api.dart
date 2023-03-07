import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../service/unauthorized_reset.dart';
import 'response_error.dart';

class API {
  late final Dio _dio;
  late final Dio _dioFile;

  static late final tempPath;

  static String? token;

  static late String baseUrl;

  API(String controller, {bool withFile = false}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: '$baseUrl$controller/',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        connectTimeout: 15000,
        sendTimeout: 30000,
        receiveTimeout: 30000,
      ),
    );
    if (withFile) {
      _dioFile = Dio(
        BaseOptions(
          baseUrl: '$baseUrl$controller/',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          connectTimeout: 15000,
        ),
      );
    }
  }

  static void refreshToken(String newToken) async {
    token = newToken;
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: 'refreshToken', value: token);
  }

  Future<dynamic> _apiRequest(Future<Response> Function() request) async {
    try {
      Response response = await request();
      if (response.statusCode == 200) {
        if (response.data['refreshToken'] != null) {
          refreshToken(response.data['refreshToken']);
        }
        print(response.data['data']);
        return response.data['data'];
      }
    } on DioError catch (e) {
      print(e);
      ResponseError error = ResponseError(
        message: 'حصل خطأ ما',
        type: ErrorType.other,
      );
      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          error.message = 'انتهت مهلة الإتصال يرجى إعادة المحاولة';
          error.type = ErrorType.connection;
          break;
        case DioErrorType.response:
          switch (e.response?.statusCode) {
            case 400:
              if (e.response?.data['refreshToken'] != null) {
                refreshToken(e.response?.data['refreshToken']);
              }
              if (e.response?.data['message'] != null) {
                error.message = e.response?.data['message'];
              }
              error.type = ErrorType.custom;
              break;
            case 401:
            case 403:
              error.type = ErrorType.unauthorized;
              unauthorizedReset();
              break;
            case 500:
              error.message = "خطأ في الوجهة حاول مرة أخرى بعد لحظات";
              error.type = ErrorType.server;
              break;
          }
          error.message = '${e.response?.statusCode} - ${error.message}';
          break;
        case DioErrorType.other:
          error.message = 'لا يوجد اتصال بالإنترنت';
          error.type = ErrorType.connection;
          break;
        case DioErrorType.cancel:
          error.message = 'تم قطع الإتصال !';
          error.type = ErrorType.connection;
          break;
      }
      throw error;
    } catch (e) {
      print(e);
      throw ResponseError(
        message: 'حصل خطأ ما',
        type: ErrorType.other,
      );
    }
  }

  Future<dynamic> get(String path) async {
    return await _apiRequest(() => _dio.get(path));
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
  }) async {
    return await _apiRequest(
      () => _dio.post(
        path,
        data: json.encode(data),
      ),
    );
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
  }) async {
    return await _apiRequest(
      () => _dio.put(
        path,
        data: json.encode(data),
      ),
    );
  }

  Future<dynamic> postFile(
    String path, {
    dynamic data,
    void Function(int, int)? onSendProgress,
  }) async {
    return await _apiRequest(
      () => _dioFile.post(
        path,
        data: data,
        onSendProgress: onSendProgress,
      ),
    );
  }

  Future<dynamic> getFile(
    String path, {
    void Function(int, int)? onSendProgress,
  }) async {
    return await _apiRequest(
      () => _dioFile.get(path),
    );
  }

  Future<dynamic> putFile(
    String path, {
    dynamic data,
    void Function(int, int)? onSendProgress,
  }) async {
    return await _apiRequest(
      () => _dioFile.put(
        path,
        data: data,
        onSendProgress: onSendProgress,
      ),
    );
  }

// Future<dynamic> delete(
//   String path, {
//   dynamic data,
// }) async {
//   print(path);
//   return await _apiRequest(
//     () => _dio.delete(path, data: json.encode(data)),
//   );
// }
}
