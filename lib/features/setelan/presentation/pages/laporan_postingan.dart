import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../komunitas/presentation/controllers/komunitas_post_controller.dart';
import '../../../komunitas/presentation/widgets/post_card.dart';
import '../../../komunitas/presentation/widgets/reported_post_card.dart';

class LaporanPostingan extends StatefulWidget {
  final UserModel user;
  const LaporanPostingan({super.key, required this.user});

  @override
  State<LaporanPostingan> createState() => _LaporanPostinganState();
}

class _LaporanPostinganState extends State<LaporanPostingan> {
  final komunitasPostController = Get.find<KomunitasPostController>();

  @override
  void initState() {
    super.initState();
    fetchReportedPosts();

    ever(komunitasPostController.postDeleted, (deleted) {
      if (deleted) {
        fetchReportedPosts();
        komunitasPostController.postDeleted.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => fetchReportedPosts(),
      child: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: komunitasPostController.status.value == Status.loading
              ? [
                  const PostLoadingCard(),
                ]
              : komunitasPostController.status.value == Status.success
                  ? komunitasPostController.posts.isNotEmpty
                      ? komunitasPostController.posts.map((post) {
                          return ReportedPostCard(user: widget.user, post: post);
                        }).toList()
                      : [
                          const DiskusiEmptyState(),
                        ]
                  : [
                      const DiskusiEmptyState(),
                    ],
        );
      }),
    );
  }

  void fetchReportedPosts() {
    komunitasPostController.fetchReportedPosts();
  }
}
