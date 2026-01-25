import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../../core/common/colors.dart';
import '../../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../auth/data/models/user_model.dart';
import '../controllers/komunitas_controller.dart';
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
  final komunitasController = Get.find<KomunitasController>();
  final List<Worker> _workers = [];

  @override
  void initState() {
    super.initState();

    // Listen for posts errors
    _workers.add(ever(komunitasController.postsStatus, (status) {
      if (!mounted) return;
      if (status == Status.error && komunitasController.errorMessage.value.isNotEmpty) {
        showSnackbar(context, message: komunitasController.errorMessage.value, isError: true);
        komunitasController.errorMessage.value = '';
      }
    }));

    // Listen for comments errors
    _workers.add(ever(komunitasController.commentsStatus, (status) {
      if (!mounted) return;
      if (status == Status.error && komunitasController.errorMessage.value.isNotEmpty) {
        showSnackbar(context, message: komunitasController.errorMessage.value, isError: true);
        komunitasController.errorMessage.value = '';
      }
    }));

    // Listen for search errors
    _workers.add(ever(komunitasController.searchStatus, (status) {
      if (!mounted) return;
      if (status == Status.error && komunitasController.errorMessage.value.isNotEmpty) {
        showSnackbar(context, message: komunitasController.errorMessage.value, isError: true);
        komunitasController.errorMessage.value = '';
      }
    }));

    // Listen for action errors (like, report, etc.)
    _workers.add(ever(komunitasController.actionStatus, (status) {
      if (!mounted) return;
      if (status == Status.error && komunitasController.errorMessage.value.isNotEmpty) {
        showSnackbar(context, message: komunitasController.errorMessage.value, isError: true);
        komunitasController.errorMessage.value = '';
      }
    }));
  }

  @override
  void dispose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    super.dispose();
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Komunitas',
                    style: mediumTS.copyWith(color: context.neutral100),
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
