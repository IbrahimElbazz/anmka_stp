import 'dart:convert';
import 'package:http/http.dart' as http;

/// API Client for making HTTP requests
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  /// Base headers for all requests
  Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// GET request
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {..._defaultHeaders, ...?headers},
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {..._defaultHeaders, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw ApiException(
        'Request failed with status ${response.statusCode}: ${response.body}',
      );
    }
  }
}

/// API Exception class
class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
