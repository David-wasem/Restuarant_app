import 'package:dio/dio.dart';

class ExceptionHandler {
  static String handle(DioException e, {String? unauthorizedMessage}) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';

      case DioExceptionType.sendTimeout:
        return 'Send timeout';

      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';

      case DioExceptionType.badResponse:
        return handleStatusCode(
          e.response?.statusCode,
          responseData: e.response?.data,
          unauthorizedMessage: unauthorizedMessage,
        );

      case DioExceptionType.cancel:
        return 'Request was cancelled';

      case DioExceptionType.connectionError:
        return 'No internet connection';

      case DioExceptionType.badCertificate:
        return 'Bad certificate';

      case DioExceptionType.unknown:
        return 'Something went wrong';

      default:
        return 'Something went wrong';
    }
  }

  static String handleStatusCode(
    int? statusCode, {
    dynamic responseData,
    String? unauthorizedMessage,
  }) {
    switch (statusCode) {
      case 400:
        if (responseData is Map<String, dynamic>) {
          final message = responseData['message'] ?? responseData['error'];
          if (message is String && message.isNotEmpty) {
            return message;
          }
        }
        return 'Bad request';

      case 401:
        return 'Invalid username or password';

      case 403:
        return 'Access denied';

      case 404:
        return 'Not found';

      case 500:
        return 'Server error';

      default:
        return 'Something went wrong';
    }
  }
}