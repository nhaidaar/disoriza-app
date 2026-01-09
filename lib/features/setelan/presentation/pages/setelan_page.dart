import 'package:disoriza/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_popup.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
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

  @override
  void initState() {
    super.initState();
    ever(authController.status, (status) {
      if (status == Status.initial && authController.user.value == null) {
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: neutral10,
        surfaceTintColor: neutral10,
        shape: const Border(
          bottom: BorderSide(color: neutral30),
        ),
        title: Text(
          'Setelan',
          style: mediumTS.copyWith(color: neutral100),
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
                  pressedColor: dangerPressed,
                  text: 'Ya, keluar',
                  onTap: () => authController.logout(),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomButton(
                  backgroundColor: neutral10,
                  pressedColor: neutral50,
                  text: 'Batal',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
