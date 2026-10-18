import 'package:api_app/exceptions/exception_handler.dart';
import 'package:api_app/services/api_dio.dart';
import 'package:dio/dio.dart';

class RestuarantApi {
  ApiDio api;
  RestuarantApi({required this.api});

  Future<dynamic> register(String email, String password) async {
    try {
      var response = await api.post({"userEmail": email, "password": password});

      return response;
    } on DioException catch (e) {
      print(ExceptionHandler.handle(e));
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      var response = await api.get(
        endpoint: "getusercode",
        queryParameters: {"userEmail": email, "password": password},
      );

      return response;
    } on DioException catch (e) {
      print(ExceptionHandler.handle(e));
    }
  }

  Future<dynamic> getCategory(String category) async {
    try {
      final response = await api.get(
        queryParameters: {"category": category.trim()},
      );

      return response;
    } on DioException catch (e) {
      print(ExceptionHandler.handle(e));
      rethrow;
    }
  }

  Future<dynamic> getMenu(int restId) async {
    try {
      final response = await api.get(
        endpoint: "$restId/menu",
      );

      return response;
    } on DioException catch (e) {
      print(ExceptionHandler.handle(e));
      rethrow;
    }
  }
}
