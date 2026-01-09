import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../../core/common/colors.dart';
import '../../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../auth/data/models/user_model.dart';
import '../controllers/komunitas_comment_controller.dart';
import '../controllers/komunitas_post_controller.dart';
import '../controllers/komunitas_search_controller.dart';
import 'komunitas_aktivitas.dart';
import 'komunitas_diskusi.dart';
import 'search_post_page.dart';

class KomunitasPage extends StatefulWidget {
  final UserModel user;
  const KomunitasPage({super.key, required this.user});

  @override
  State<KomunitasPage> createState() => _KomunitasPageState();
}

class _KomunitasPageState extends State<KomunitasPage> {
  final komunitasPostController = Get.find<KomunitasPostController>();
  final komunitasCommentController = Get.find<KomunitasCommentController>();
  final komunitasSearchController = Get.find<KomunitasSearchController>();

  @override
  void initState() {
    super.initState();
    ever(komunitasPostController.status, (status) {
      if (status == Status.error && komunitasPostController.errorMessage.value.isNotEmpty) {
        showSnackbar(context, message: komunitasPostController.errorMessage.value, isError: true);
        komunitasPostController.errorMessage.value = '';
      }
    });

    ever(komunitasCommentController.status, (status) {
      if (status == Status.error && komunitasCommentController.errorMessage.value.isNotEmpty) {
        showSnackbar(context, message: komunitasCommentController.errorMessage.value, isError: true);
        komunitasCommentController.errorMessage.value = '';
      }
    });

    ever(komunitasSearchController.status, (status) {
      if (status == Status.error && komunitasSearchController.errorMessage.value.isNotEmpty) {
        showSnackbar(context, message: komunitasSearchController.errorMessage.value, isError: true);
        komunitasSearchController.errorMessage.value = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 128,
          backgroundColor: neutral10,
          surfaceTintColor: neutral10,
          shape: const Border(
            bottom: BorderSide(color: neutral30),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Komunitas',
                    style: mediumTS.copyWith(color: neutral100),
                  ),

                  IconButton(
                    onPressed: () => Get.to(() => SearchPostPage(user: widget.user)),
                    icon: const Icon(IconsaxPlusLinear.search_normal_1),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: backgroundCanvas,
                ),
                child: TabBar(
                  labelStyle: mediumTS.copyWith(fontSize: 16, color: accentGreenMain),
                  unselectedLabelStyle: mediumTS.copyWith(fontSize: 16, color: neutral60),
                  indicator: BoxDecoration(
                    color: neutral10,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  splashBorderRadius: BorderRadius.circular(100),
                  dividerHeight: 0,
                  tabs: const [
                    Tab(text: 'Diskusi'),
                    Tab(text: 'Aktivitasmu'),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            KomunitasDiskusi(user: widget.user),
            KomunitasAktivitas(user: widget.user),
          ],
        ),
      ),
    );
  }
}
