import 'package:disoriza/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_popup.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/setelan_controller.dart';
import '../widgets/setelan_menu.dart';
import 'edit_profile_page.dart';
import 'laporan_page.dart';
import 'ubah_email_page.dart';
import 'ubah_password_page.dart';

class SetelanPage extends StatefulWidget {
  final UserModel user;
  const SetelanPage({super.key, required this.user});

  @override
  State<SetelanPage> createState() => _SetelanPageState();
}

class _SetelanPageState extends State<SetelanPage> {
  final authController = Get.find<AuthController>();
  final setelanController = Get.find<SetelanController>();
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.neutral10,
        surfaceTintColor: context.neutral10,
        shape: Border(bottom: BorderSide(color: context.neutral30)),
        title: Text(
          'Setelan',
          style: mediumTS.copyWith(color: context.neutral100),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          if (widget.user.isAdmin) ...[
            SetelanMenu(
              icon: IconsaxPlusLinear.info_circle,
              title: 'Laporan',
              iconColor: successMain,
              onTap: () => Get.to(() => LaporanPage(user: widget.user)),
            ),

            const SizedBox(height: 16),
          ],

          SetelanMenu(
            icon: IconsaxPlusLinear.profile,
            title: 'Edit profile',
            onTap: () => Get.to(() => EditProfilePage(user: widget.user)),
          ),

          SetelanMenu(
            icon: IconsaxPlusLinear.sms,
            title: 'Ubah email',
            onTap: () => Get.to(() => UbahEmailPage(user: widget.user)),
          ),

          SetelanMenu(
            icon: IconsaxPlusLinear.key,
            title: 'Ubah password',
            onTap: () => Get.to(() => UbahPasswordPage(user: widget.user)),
          ),

          const SizedBox(height: 16),

          Obx(
            () => SetelanMenu(
              icon: IconsaxPlusLinear.moon,
              title: 'Tema',
              subtitle: themeController.getThemeLabel(
                themeController.themeMode.value,
              ),
              onTap: () => _showThemePicker(context),
            ),
          ),

          const SizedBox(height: 16),

          SetelanMenu(
            icon: IconsaxPlusLinear.logout,
            iconColor: dangerMain,
            enableArrowRight: false,
            title: 'Keluar',
            onTap: () => handleLogout(context),
          ),
        ],
      ),
    );
  }

  Future<void> handleLogout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => CustomPopup(
        icon: IconsaxPlusLinear.logout,
        iconColor: dangerMain,
        title: 'Ingin keluar?',
        subtitle: 'Setelah keluar dari aplikasi, kamu dapat login kembali.',
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  backgroundColor: dangerMain,
                  text: 'Ya, keluar',
                  onTap: () {
                    authController.logout();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomButton(
                  backgroundColor: context.neutral10,
                  textColor: context.neutral100,
                  borderColor: context.neutral30,
                  text: 'Batal',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomPopup(
        icon: IconsaxPlusLinear.moon,
        iconColor: context.accentGreen,
        title: 'Pilih Tema',
        actions: [
          Column(
            children: [
              _buildThemeOption(dialogContext, 'Sistem', ThemeMode.system),
              const SizedBox(height: 8),
              _buildThemeOption(dialogContext, 'Terang', ThemeMode.light),
              const SizedBox(height: 8),
              _buildThemeOption(dialogContext, 'Gelap', ThemeMode.dark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String label, ThemeMode mode) {
    final isSelected = themeController.themeMode.value == mode;

    return CustomButton(
      onTap: () {
        themeController.setThemeMode(mode);
        Navigator.of(context).pop();
      },
      text: label,
      textColor: isSelected ? context.neutral10 : context.neutral100,
      borderColor: isSelected ? null : context.neutral30,
      backgroundColor: isSelected ? context.accentGreen : context.neutral10,
    );
  }
}
