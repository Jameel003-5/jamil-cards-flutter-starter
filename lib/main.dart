import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/dashboard/dashboard_overview_screen.dart';
import 'screens/dashboard/nfc_tags_screen.dart';
import 'binding.dart';
import 'config.dart';
import 'middleware/auth_middleware.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(
    GetMaterialApp(
      title: 'Smart Business Cards',
      theme: ThemeData(
        primaryColor: UiConfig.colorSec,
        fontFamily: UiConfig.fontPrime,
        scaffoldBackgroundColor: UiConfig.colorPrime,
        colorScheme: ColorScheme.fromSeed(
          seedColor: UiConfig.colorSec,
          primary: UiConfig.colorSec,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: UiConfig.colorSec),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: UiConfig.colorSec, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: UiConfig.colorSec,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialBinding: Binding(),
      initialRoute: '/',
      getPages: [
        // Auth routes
        GetPage(
          name: '/',
          page: () => AuthScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/signup',
          page: () => SignUpScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/forgot-password',
          page: () => ForgotPasswordScreen(),
        ),
        
        // Dashboard routes
        GetPage(
          name: '/dashboard',
          page: () => DashboardOverviewScreen(),
          middlewares: [AuthMiddleware()],
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/dashboard/tags',
          page: () => NFCTagsScreen(),
          middlewares: [AuthMiddleware()],
          transition: Transition.fadeIn,
        ),
      ],
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
    ),
  );
}
