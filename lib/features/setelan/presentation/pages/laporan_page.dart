import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../komunitas/presentation/controllers/komunitas_controller.dart';
import 'laporan_komentar.dart';
import 'laporan_postingan.dart';

class LaporanPage extends StatefulWidget {
  final UserModel user;
  const LaporanPage({super.key, required this.user});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final komunitasController = Get.find<KomunitasController>();

  @override
  void initState() {
    super.initState();

    // Listen for posts errors
    ever(komunitasController.postsStatus, (status) {
      if (status == Status.error && komunitasController.errorMessage.value.isNotEmpty) {
        showSnackbar(context, message: komunitasController.errorMessage.value, isError: true);
        komunitasController.errorMessage.value = '';
      }
    });

    // Listen for comments errors
    ever(komunitasController.commentsStatus, (status) {
      if (status == Status.error && komunitasController.errorMessage.value.isNotEmpty) {
        showSnackbar(context, message: komunitasController.errorMessage.value, isError: true);
        komunitasController.errorMessage.value = '';
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
          backgroundColor: context.neutral10,
          surfaceTintColor: context.neutral10,
          shape: Border(
            bottom: BorderSide(color: context.neutral30),
          ),

          leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(IconsaxPlusLinear.arrow_left),
          ),

          title: Text(
            'Laporan',
            style: mediumTS.copyWith(color: context.neutral100),
          ),
          centerTitle: true,

          bottom: PreferredSize(
            preferredSize: Size.zero,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: context.backgroundCanvas,
              ),
              child: TabBar(
                labelStyle: mediumTS.copyWith(fontSize: 16, color: context.accentGreen),
                unselectedLabelStyle: mediumTS.copyWith(fontSize: 16, color: context.neutral60),
                indicator: BoxDecoration(
                  color: context.neutral10,
                  borderRadius: BorderRadius.circular(100),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                splashBorderRadius: BorderRadius.circular(100),
                dividerHeight: 0,
                tabs: const [
                  Tab(text: 'Postingan'),
                  Tab(text: 'Komentar'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            LaporanPostingan(user: widget.user),
            LaporanKomentar(user: widget.user),
          ],
        ),
      ),
    );
  }
}
