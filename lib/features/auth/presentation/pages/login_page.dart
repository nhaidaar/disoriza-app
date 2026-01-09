import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_textfield.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../controllers/auth_controller.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool passwordHidden = true;
  bool areFieldsEmpty = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(updateFieldState);
    _passwordController.addListener(updateFieldState);
  }

  void updateFieldState() {
    setState(() {
      areFieldsEmpty = _emailController.text.isEmpty || _passwordController.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.removeListener(updateFieldState);
    _passwordController.removeListener(updateFieldState);
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Text('Email', style: mediumTS.copyWith(color: neutral100)),
          const SizedBox(height: 8),
          CustomFormField(
            controller: _emailController,
            hint: 'Masukkan email anda',
          ),

          const SizedBox(height: 12),

          Text('Password', style: mediumTS.copyWith(color: neutral100)),
          const SizedBox(height: 8),
          CustomFormField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            isPassword: true,
            hint: 'Masukkan password anda',
            obscureText: passwordHidden,
            onTap: () {
              setState(() => passwordHidden = !passwordHidden);
            },
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => Get.to(() => const ForgotPasswordPage()),
                child: Text(
                  'Lupa password?',
                  style: mediumTS.copyWith(color: neutral100),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Obx(() {
            if (authController.status.value == Status.loading) {
              return const CustomLoadingButton();
            }
            return CustomButton(
              text: 'Masuk',
              disabled: areFieldsEmpty,
              onTap: () {
                authController.login(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
