abstract class ApiServices {
  Future<dynamic> delete(int id);
  Future<dynamic> get({
    int? id,
    String? endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
  Future<dynamic> patch(int id, Map<String, dynamic> data);
  Future<dynamic> post(Map<String, dynamic> data);
}
