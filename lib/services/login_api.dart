import 'package:api_app/exceptions/exception_handler.dart';
import 'package:api_app/services/api_dio.dart';
import 'package:dio/dio.dart';

class LoginApi {
  ApiDio api;
  LoginApi({required this.api});

  Future<dynamic> login(String username, String password) async {
    try {
      final response = await api.post({
        'username': username,
        'password': password,
      });
      return response;
    } on DioException catch (e) {
      final message = ExceptionHandler.handle(e);
      print(message);
      rethrow;
    }
  }

  Future<dynamic> register(Map<String, dynamic> data) async {
    try {
      final response = await api.post(data);

      return response;
    } on DioException catch (e) {
      final mess = ExceptionHandler.handle(e);
      print(mess);
      rethrow;
    }
  }

  Future<dynamic> getProfile(String accessToken) async {
    try {
      final response = await api.get(
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      return response;
    } on DioException catch (e) {
      final mess = ExceptionHandler.handle(e);
      print(mess);
      rethrow;
    }
  }
}
