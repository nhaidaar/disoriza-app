import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/custom_textfield.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_popup.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/utils/camera.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../auth/data/models/user_model.dart';
import '../controllers/komunitas_controller.dart';

class CreatePostPage extends StatefulWidget {
  final UserModel user;
  const CreatePostPage({super.key, required this.user});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final komunitasController = Get.find<KomunitasController>();
  Uint8List? image;

  bool areFieldsEmpty = true;

  void updateFieldState() {
    setState(() {
      areFieldsEmpty =
          _titleController.text.isEmpty || _descriptionController.text.isEmpty;
    });
  }

  Future<bool> _onPopInvoked() async {
    if (areFieldsEmpty) {
      return true;
    }

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CustomPopup(
          icon: IconsaxPlusLinear.trash,
          iconColor: dangerMain,
          title: 'Ingin batalkan postingan?',
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.of(context).pop(true),
                    text: 'Ya, Batalkan',
                    backgroundColor: dangerMain,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.of(context).pop(false),
                    text: 'Tidak, lanjut',
                    backgroundColor: context.neutral10,
                    borderColor: context.neutral50,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    return shouldPop ?? false;
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(updateFieldState);
    _descriptionController.addListener(updateFieldState);

    ever(komunitasController.postCreated, (created) {
      if (created) {
        Get.back();
        showSnackbar(context, message: 'Postingan berhasil terunggah');
        komunitasController.postCreated.value = false;
      }
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(updateFieldState);
    _descriptionController.removeListener(updateFieldState);
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: areFieldsEmpty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onPopInvoked();
        if (shouldPop && context.mounted) Get.back();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.neutral10,
          surfaceTintColor: context.neutral10,
          shape: Border(bottom: BorderSide(color: context.neutral30)),

          leading: IconButton(
            onPressed: () async {
              if (await _onPopInvoked()) {
                Get.back();
              }
            },
            icon: const Icon(IconsaxPlusLinear.arrow_left),
          ),

          title: Text(
            'Buat postingan',
            style: mediumTS.copyWith(fontSize: 16, color: context.neutral100),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Judul',
                    style: mediumTS.copyWith(color: context.neutral100),
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    controller: _titleController,
                    hint: 'Isi Judul',
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Deskripsi',
                    style: mediumTS.copyWith(color: context.neutral100),
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    controller: _descriptionController,
                    hint: 'Isi Deskripsi',
                    maxLines: 8,
                    borderradius: 16,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Foto (Opsional)',
                    style: mediumTS.copyWith(color: context.neutral100),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: context.neutral10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: image != null ? 212 : 141,
                          decoration: BoxDecoration(
                            border: Border.all(color: context.neutral30),
                            borderRadius: BorderRadius.circular(24),
                            image: image != null
                                ? DecorationImage(
                                    image: MemoryImage(image!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: image != null
                              ? null
                              : Center(
                                  child: Text(
                                    'Silahkan upload gambar\nterlebih dahulu',
                                    style: mediumTS.copyWith(
                                      fontSize: 12,
                                      color: context.neutral70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 8),

                        GestureDetector(
                          onTap: () async {
                            XFile? pickedImage = await pickImage(context);
                            if (pickedImage != null) {
                              final imageBytes = await pickedImage
                                  .readAsBytes();
                              setState(() => image = imageBytes);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: context.neutral30),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              image != null ? 'Ubah Gambar' : 'Upload Gambar',
                              style: mediumTS.copyWith(
                                fontSize: 12,
                                color: context.neutral100,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                if (komunitasController.actionStatus.value == Status.loading) {
                  return const CustomLoadingButton();
                }
                return CustomButton(
                  text: 'Posting',
                  disabled: areFieldsEmpty,
                  onTap: () {
                    komunitasController.createPost(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      uid: widget.user.id.toString(),
                      image: image,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
