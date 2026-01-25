import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_textfield.dart';
import '../../../../core/common/effects.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/utils/camera.dart';
import '../../../../core/utils/network_image.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/setelan_controller.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _namaController = TextEditingController();
  final setelanController = Get.find<SetelanController>();
  final authController = Get.find<AuthController>();
  Uint8List? image;
  Worker? _profileUpdateWorker;

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.user.name ?? '';

    _profileUpdateWorker = ever(setelanController.updatedProfile, (profile) {
      if (profile != null && mounted) {
        showSnackbar(context, message: 'Profil telah diperbarui');
        authController.updateUser(profile);
        setelanController.updatedProfile.value = null;
      }
    });
  }

  @override
  void dispose() {
    _profileUpdateWorker?.dispose();
    _namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.neutral10,
        surfaceTintColor: context.neutral10,
        shape: Border(
          bottom: BorderSide(color: context.neutral30),
        ),

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(IconsaxPlusLinear.arrow_left),
        ),

        title: Text(
          'Edit Profile',
          style: mediumTS.copyWith(fontSize: 16, color: context.neutral100),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.neutral10,
            borderRadius: defaultSmoothRadius,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(side: BorderSide(color: context.neutral50)),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: context.neutral10,
                        backgroundImage: image != null
                            ? MemoryImage(image!)
                            : widget.user.profilePicture != null
                                ? getImageProvider(widget.user.profilePicture.toString())
                                : null,
                        child: image != null
                            ? null
                            : widget.user.profilePicture != null
                                ? null
                                : Icon(IconsaxPlusLinear.profile, color: context.neutral100, size: 32),
                      ),
                    ),

                    GestureDetector(
                      onTap: () async {
                        XFile? pickedImage = await pickImage(context);
                        if (pickedImage != null) {
                          final imageBytes = await pickedImage.readAsBytes();
                          setState(() => image = imageBytes);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: context.neutral10,
                          boxShadow: const [shadowEffect1],
                        ),
                        child: const Icon(IconsaxPlusLinear.edit, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              Text('Nama', style: mediumTS.copyWith(color: context.neutral100)),
              const SizedBox(height: 8),
              CustomFormField(
                controller: _namaController,
                backgroundColor: context.backgroundCanvas,
                hint: 'Masukkan nama anda',
              ),

              const SizedBox(height: 24),

              Obx(() {
                if (setelanController.status.value == Status.loading) {
                  return const CustomLoadingButton();
                }
                return CustomButton(
                  onTap: () => setelanController.changeProfile(
                    uid: widget.user.id!,
                    name: _namaController.text,
                    image: image,
                  ),
                  text: 'Simpan',
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
