import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_textfield.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool passwordHidden = true;
  bool areFieldsEmpty = true;

  @override
  void initState() {
    super.initState();
    _namaController.addListener(updateFieldState);
    _emailController.addListener(updateFieldState);
    _passwordController.addListener(updateFieldState);
  }

  void updateFieldState() {
    setState(() => areFieldsEmpty =
        _namaController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty);
  }

  @override
  void dispose() {
    _namaController.removeListener(updateFieldState);
    _emailController.removeListener(updateFieldState);
    _passwordController.removeListener(updateFieldState);
    _namaController.dispose();
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
          Text('Nama', style: mediumTS.copyWith(color: context.neutral100)),
          const SizedBox(height: 8),
          CustomFormField(
            controller: _namaController,
            hint: 'Masukkan nama anda',
          ),

          const SizedBox(height: 12),

          Text('Email', style: mediumTS.copyWith(color: context.neutral100)),
          const SizedBox(height: 8),
          CustomFormField(
            controller: _emailController,
            hint: 'Masukkan email anda',
          ),

          const SizedBox(height: 12),

          Text('Password baru', style: mediumTS.copyWith(color: context.neutral100)),
          const SizedBox(height: 8),
          CustomFormField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            isPassword: true,
            hint: 'Buat password baru anda',
            obscureText: passwordHidden,
            onTap: () {
              setState(() => passwordHidden = !passwordHidden);
            },
          ),

          const SizedBox(height: 24),

          Obx(() {
            if (authController.status.value == Status.loading) {
              return const CustomLoadingButton();
            }
            return CustomButton(
              text: 'Daftar',
              disabled: areFieldsEmpty,
              onTap: () {
                authController.register(
                  name: _namaController.text,
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
