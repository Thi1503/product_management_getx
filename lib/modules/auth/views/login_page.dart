import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/modules/auth/controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // ignore: deprecated_member_use
                  _theme.primaryColor.withOpacity(0.8),
                  _theme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // 2. Form card
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Title
                const SizedBox(height: 48),
                Text(
                  'Đăng nhập',
                  style: _theme.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 48),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Obx(
                      () => Form(
                        key: controller.formKey,
                        autovalidateMode:
                            controller.submitted.value
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Mã số thuế
                            TextFormField(
                              controller: controller.taxCodeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Mã số thuế',
                                prefixIcon: Icon(Icons.confirmation_number),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mã số thuế không được để trống';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Tên đăng nhập
                            TextFormField(
                              controller: controller.usernameController,
                              decoration: InputDecoration(
                                labelText: 'Tên đăng nhập',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Tên đăng nhập không được để trống';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: controller.passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 6 ||
                                    value.length > 50) {
                                  return 'Mật khẩu phải từ 6 đến 50 ký tự';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed:
                                    controller.isLoading.value
                                        ? null
                                        : controller.login,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child:
                                    controller.isLoading.value
                                        ? CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                            Colors.white,
                                          ),
                                        )
                                        : Text(
                                          'Đăng nhập',
                                          style: TextStyle(fontSize: 16),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
