import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoggedIn = false.obs;

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  Future<void> checkAuthStatus() async {
    isLoggedIn.value = _storageService.isLoggedIn();
    if (isLoggedIn.value) {
      Get.offAllNamed('/home');
    }
  }

  Future<void> signInWithEmail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final email = emailController.text.trim();
      final password = passwordController.text;

      final response = await _apiService.login(email, password);
      
      await _handleAuthResponse(response);
      Get.offAllNamed('/home');

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        duration: Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;

      final response = await _apiService.register(name, email, password);
      
      await _handleAuthResponse(response);
      Get.offAllNamed('/home');

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final email = emailController.text.trim();
      await _apiService.resetPassword(email);

      Get.snackbar(
        'Success',
        'Password reset link has been sent to your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade900,
      );

      Get.back(); // Return to login screen

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement Google Sign In
      // 1. Get Google Sign In token
      // 2. Send token to backend
      final token = 'google-token';
      final response = await _apiService.socialLogin('google', token);
      
      await _handleAuthResponse(response);
      Get.offAllNamed('/home');

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement Facebook Sign In
      // 1. Get Facebook Sign In token
      // 2. Send token to backend
      final token = 'facebook-token';
      final response = await _apiService.socialLogin('facebook', token);
      
      await _handleAuthResponse(response);
      Get.offAllNamed('/home');

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithLinkedIn() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement LinkedIn Sign In
      // 1. Get LinkedIn Sign In token
      // 2. Send token to backend
      final token = 'linkedin-token';
      final response = await _apiService.socialLogin('linkedin', token);
      
      await _handleAuthResponse(response);
      Get.offAllNamed('/home');

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _storageService.clearAll();
    isLoggedIn.value = false;
    Get.offAllNamed('/');
  }

  Future<void> _handleAuthResponse(Map<String, dynamic> response) async {
    final token = response['token'];
    final userData = response['user'];

    await _storageService.saveToken(token);
    await _storageService.saveUser(userData);
    isLoggedIn.value = true;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void clearError() {
    errorMessage.value = '';
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    clearError();
  }
}
