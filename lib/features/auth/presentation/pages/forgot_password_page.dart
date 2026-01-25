import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_popup.dart';
import '../../../../core/common/custom_textfield.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final authController = Get.find<AuthController>();
  bool isEmailEmpty = true;
  Worker? _passwordResetWorker;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(updateFieldState);

    // Listen for password reset success using GetX worker
    _passwordResetWorker = ever(authController.passwordReseted, (isReseted) {
      if (isReseted && mounted) {
        authController.passwordReseted.value = false;
        handlePasswordReseted(context);
      }
    });
  }

  void updateFieldState() {
    setState(() => isEmailEmpty = _emailController.text.isEmpty);
  }

  @override
  void dispose() {
    _passwordResetWorker?.dispose();
    _emailController.removeListener(updateFieldState);
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(IconsaxPlusLinear.arrow_left),
        ),
        backgroundColor: context.neutral10,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            color: context.neutral10,
            child: Column(
              children: [
                Text(
                  'Reset password',
                  style: mediumTS.copyWith(fontSize: 24, color: context.neutral100),
                ),

                const SizedBox(height: 16),

                Text(
                  'Masukkan email anda untuk mendapatkan link reset password.',
                  style: mediumTS.copyWith(color: context.neutral100.withValues(alpha: 0.6)),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              children: [
                const Text(
                  'Email',
                  style: mediumTS,
                ),
                const SizedBox(height: 8),
                CustomFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'Masukkan email anda',
                ),

                const SizedBox(height: 24),

                Obx(() {
                  if (authController.status.value == Status.loading) {
                    return const CustomLoadingButton();
                  }

                  return CustomButton(
                    onTap: () => authController.resetPassword(email: _emailController.text),
                    disabled: isEmailEmpty,
                    text: 'Konfirmasi',
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handlePasswordReseted(BuildContext context) {
    return showDialog(
      context: context,
      builder: (dialogContext) => CustomPopup(
        icon: IconsaxPlusBold.tick_circle,
        iconColor: context.accentGreen,
        title: 'Email terkirim!',
        subtitle: 'Kami telah mengirimkan link reset password ke email ${_emailController.text}',
        actions: [
          CustomButton(
            onTap: () => Navigator.of(dialogContext).pop(),
            text: 'Oke',
          ),
        ],
      ),
    );
  }
}
