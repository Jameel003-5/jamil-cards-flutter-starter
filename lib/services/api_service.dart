import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'storage_service.dart';

class ApiService {
  // TODO: Replace with your actual API base URL
  static const String baseUrl = 'https://api.example.com/v1';
  
  final StorageService _storageService = StorageService();

  Map<String, String> get _headers {
    final token = _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Authentication endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: _headers,
        body: jsonEncode({'email': email}),
      );

      _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // NFC Tag endpoints
  Future<List<dynamic>> getTags() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tags'),
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createTag(String uid) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tags'),
        headers: _headers,
        body: jsonEncode({'uid': uid}),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> activateTag(String tagId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tags/$tagId/activate'),
        headers: _headers,
        body: jsonEncode({'userId': userId}),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deactivateTag(String tagId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tags/$tagId/deactivate'),
        headers: _headers,
      );

      _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteTag(String tagId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/tags/$tagId'),
        headers: _headers,
      );

      _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic HTTP methods
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );

      _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    }

    if (response.statusCode == 401) {
      // Token expired or invalid
      _storageService.clearAll();
      Get.offAllNamed('/');
      throw 'Session expired. Please login again.';
    }

    throw _parseErrorMessage(response);
  }

  String _parseErrorMessage(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['message'] ?? 'An error occurred';
    } catch (e) {
      return 'Server error: ${response.statusCode}';
    }
  }

  String _handleError(dynamic error) {
    if (error is http.Response) {
      return _parseErrorMessage(error);
    }
    return error.toString();
  }
}
