import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/colors.dart';
import '../common/custom_button.dart';
import '../common/effects.dart';
import '../common/fontstyles.dart';

Future<int> deviceSDK() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt;
  }
  return 0;
}

Future<bool> getPermission(ImageSource source) async {
  final olderAndroid = Platform.isAndroid && await deviceSDK() < 33;

  final permission = source == ImageSource.camera
      ? await Permission.camera.status
      : olderAndroid
      ? await Permission.storage.status
      : await Permission.photos.status;

  if (permission != PermissionStatus.granted) {
    return source == ImageSource.camera
        ? await Permission.camera.request().isGranted
        : olderAndroid
        ? await Permission.storage.request().isGranted
        : await Permission.photos.request().isGranted;
  }
  return true;
}

Future<XFile?> pickImage(BuildContext context) async {
  ImageSource? source;

  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: defaultSmoothRadius),
      backgroundColor: context.neutral10,
      surfaceTintColor: context.neutral10,
      titlePadding: const EdgeInsets.all(12),
      title: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Ingin mengupload gambar darimana?',
              style: mediumTS.copyWith(fontSize: 16, color: context.neutral100),
            ),

            const SizedBox(height: 8),

            // Ambil foto
            PickImageButton(
              icon: IconsaxPlusLinear.camera,
              title: 'Ambil Foto',
              onTap: () {
                source = ImageSource.camera;
                Navigator.of(dialogContext).pop();
              },
            ),

            const SizedBox(height: 4),

            // Pilih dari galeri
            PickImageButton(
              icon: IconsaxPlusLinear.gallery_add,
              title: 'Pilih dari Galeri',
              onTap: () {
                source = ImageSource.gallery;
                Navigator.of(dialogContext).pop();
              },
            ),

            const SizedBox(height: 8),

            CustomButton(
              onTap: () => Navigator.of(dialogContext).pop(),
              text: 'Batal',
              textColor: context.neutral100,
              backgroundColor: context.neutral10,
              borderColor: context.neutral30,
            ),
          ],
        ),
      ),
    ),
  );

  if (source == null) return null;

  final permissionGranted = await getPermission(source!);
  if (permissionGranted)
    return await ImagePicker().pickImage(source: source!, imageQuality: 80);
  return null;
}

class PickImageButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  const PickImageButton({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: context.neutral50,
      highlightColor: context.neutral50,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.neutral20,
          borderRadius: halfSmoothRadius,
          border: Border.all(color: context.neutral30),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.neutral10,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: context.neutral100),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: mediumTS.copyWith(fontSize: 16, color: context.neutral100),
            ),
          ],
        ),
      ),
    );
  }
}
