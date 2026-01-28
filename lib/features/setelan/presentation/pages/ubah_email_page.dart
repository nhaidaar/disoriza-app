import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_popup.dart';
import '../../../../core/common/custom_textfield.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../controllers/setelan_controller.dart';

class UbahEmailPage extends StatefulWidget {
  final UserModel user;
  const UbahEmailPage({super.key, required this.user});

  @override
  State<UbahEmailPage> createState() => _UbahEmailPageState();
}

class _UbahEmailPageState extends State<UbahEmailPage> {
  final _emailController = TextEditingController();
  final setelanController = Get.find<SetelanController>();
  bool isEmailDifferent = false;

  Worker? _emailChangedWorker;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.email.toString();
    _emailController.addListener(updateFieldState);

    _emailChangedWorker = ever(setelanController.emailChanged, (changed) {
      if (changed) {
        handleUbahEmail(context);
        setelanController.emailChanged.value = false;
      }
    });
  }

  @override
  void dispose() {
    _emailChangedWorker?.dispose();
    _emailController.removeListener(updateFieldState);
    _emailController.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() => isEmailDifferent = _emailController.text != widget.user.email.toString());
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
                  'Ubah email',
                  style: mediumTS.copyWith(fontSize: 24, color: context.neutral100),
                ),

                const SizedBox(height: 16),

                Text(
                  'Masukkan email baru Anda untuk mendapatkan link konfirmasi ubah email.',
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
                  if (setelanController.status.value == Status.loading) {
                    return const CustomLoadingButton();
                  }
                  return CustomButton(
                    onTap: () => setelanController.changeEmail(email: _emailController.text),
                    disabled: !isEmailDifferent,
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

  void handleUbahEmail(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomPopup(
        icon: IconsaxPlusBold.tick_circle,
        iconColor: context.accentGreen,
        title: 'Email terkirim!',
        subtitle: 'Kami telah mengirimkan konfirmasi ubah email ke ${_emailController.text}',
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
