import 'package:api_app/exceptions/exception_handler.dart';
import 'package:api_app/services/api_services.dart';
import 'package:dio/dio.dart';

class ApiDio extends ApiServices {
  String baseURL;
  Dio? dio;

  ApiDio({required this.baseURL, required this.dio});

  @override
  Future<dynamic> delete(int id) async {
    try {
      var response = await dio?.delete('$baseURL/$id');
      var data = response?.data as Map<String, dynamic>;

      return data;
    } on DioException catch (e) {
      print(ExceptionHandler.handle(e));
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  @override
  Future<dynamic> get({
    int? id,
    String? endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      String requestUrl;

      if (endpoint != null) {
        requestUrl = '$baseURL/$endpoint';
      } else if (id != null) {
        requestUrl = '$baseURL/$id';
      } else {
        requestUrl = baseURL;
      }

      final response = await dio?.get(
        requestUrl,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response?.data;
    } on DioException catch (e) {
      print(ExceptionHandler.handle(e));
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  @override
  Future<dynamic> patch(int id, Map<String, dynamic> data) async {
    try {
      var response = await dio?.patch('$baseURL/$id', data: data);

      var resposeData = response?.data as Map<String, dynamic>;
      return resposeData;
    } on DioException catch (e) {
      print(ExceptionHandler.handle(e));
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  @override
  Future<dynamic> post(Map<String, dynamic> data) async {
    try {
      var response = await dio?.post(baseURL, data: data);

      return response?.data;
    } on DioException catch (e) {
      print(ExceptionHandler.handle(e));
      rethrow;
    }
  }
}
