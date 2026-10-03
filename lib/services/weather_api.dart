import 'package:api_app/exceptions/exception_handler.dart';
import 'package:api_app/services/api_dio.dart';
import 'package:api_app/services/api_keys.dart';
import 'package:dio/dio.dart';

class WeatherApi {
  ApiDio api;
  WeatherApi({required this.api});

  Future<dynamic> getWeatherData({
    required String endpoint,
    required String location,
  }) async {
    try {
      final response = await api.get(
        endpoint: endpoint,
        queryParameters: {'key': ApiKeys.weatherAPIKEY, 'q': location},
      );

      return response;
    } on DioException catch (e) {
      print(ExceptionHandler.handle(e));
      rethrow;
    }
  }

  Future<dynamic> getCurrent({required String location}) {
    return getWeatherData(
      endpoint: ApiKeys.currentENDPOINT,
      location: location,
    );
  }

  Future<dynamic> getAstronomy({required String location}) {
    return getWeatherData(
      endpoint: ApiKeys.astronomyENDPOINT,
      location: location,
    );
  }
}
