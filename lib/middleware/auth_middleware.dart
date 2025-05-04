import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class AuthMiddleware extends GetMiddleware {
  final StorageService _storageService = StorageService();

  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in and is an admin
    final token = _storageService.getToken();
    final userData = _storageService.getUser();
    
    // If trying to access dashboard routes
    if (route?.startsWith('/dashboard') == true) {
      if (token == null) {
        // Not logged in, redirect to login
        return RouteSettings(name: '/');
      }
      
      // Check if user is admin
      final isAdmin = userData?['role'] == 'admin';
      if (!isAdmin) {
        // Not an admin, redirect to home
        return RouteSettings(name: '/home');
      }
    }

    // If trying to access auth routes while logged in
    if ((route == '/' || route == '/signup') && token != null) {
      // Already logged in, redirect to appropriate screen
      final isAdmin = userData?['role'] == 'admin';
      return RouteSettings(name: isAdmin ? '/dashboard' : '/home');
    }

    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }
}
