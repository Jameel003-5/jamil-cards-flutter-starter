import 'package:get_storage/get_storage.dart';

class StorageService {
  static const String KEY_TOKEN = 'auth_token';
  static const String KEY_USER = 'user_data';

  final _storage = GetStorage();

  // Store authentication token
  Future<void> saveToken(String token) async {
    await _storage.write(KEY_TOKEN, token);
  }

  // Get stored authentication token
  String? getToken() {
    return _storage.read(KEY_TOKEN);
  }

  // Remove authentication token
  Future<void> removeToken() async {
    await _storage.remove(KEY_TOKEN);
  }

  // Store user data
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await _storage.write(KEY_USER, userData);
  }

  // Get stored user data
  Map<String, dynamic>? getUser() {
    return _storage.read(KEY_USER);
  }

  // Remove user data
  Future<void> removeUser() async {
    await _storage.remove(KEY_USER);
  }

  // Clear all stored data
  Future<void> clearAll() async {
    await _storage.erase();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return getToken() != null;
  }
}
