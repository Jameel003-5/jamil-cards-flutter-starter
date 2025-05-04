import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/error_message.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConfig.colorPrime,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: UiConfig.dark),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              padding: EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_reset,
                        size: 64,
                        color: UiConfig.colorSec,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: UiConfig.fontPrime,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Enter your email address to receive a password reset link',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: UiConfig.fontPrime,
                        ),
                      ),
                      SizedBox(height: 32),
                      if (controller.errorMessage.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: ErrorMessage(
                            message: controller.errorMessage.value,
                            onDismiss: controller.clearError,
                          ),
                        ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!GetUtils.isEmail(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await controller.resetPassword();
                                  }
                                },
                                child: Text(
                                  'Send Reset Link',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: UiConfig.fontPrime,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
