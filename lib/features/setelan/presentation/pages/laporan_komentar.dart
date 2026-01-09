import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../komunitas/presentation/controllers/komunitas_comment_controller.dart';
import '../../../komunitas/presentation/controllers/komunitas_post_controller.dart';
import '../../../komunitas/presentation/widgets/post_card.dart';
import '../../../komunitas/presentation/widgets/reported_comment_card.dart';

class LaporanKomentar extends StatefulWidget {
  final UserModel user;
  const LaporanKomentar({super.key, required this.user});

  @override
  State<LaporanKomentar> createState() => _LaporanKomentarState();
}

class _LaporanKomentarState extends State<LaporanKomentar> {
  final komunitasPostController = Get.find<KomunitasPostController>();
  final komunitasCommentController = Get.find<KomunitasCommentController>();

  @override
  void initState() {
    super.initState();
    fetchReportedComments();

    ever(komunitasCommentController.commentDeleted, (deleted) {
      if (deleted) {
        fetchReportedComments();
        komunitasCommentController.commentDeleted.value = false;
      }
    });

    ever(komunitasPostController.postDeleted, (deleted) {
      if (deleted) {
        fetchReportedComments();
        komunitasPostController.postDeleted.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => fetchReportedComments(),
      child: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: komunitasPostController.status.value == Status.loading
              ? [
                  const PostLoadingCard(),
                ]
              : komunitasPostController.status.value == Status.success
                  ? komunitasPostController.reportedComments.isNotEmpty
                      ? komunitasPostController.reportedComments.map((model) {
                          return ReportedCommentCard(
                            user: widget.user,
                            comment: model.commentModel,
                            post: model.postModel,
                          );
                        }).toList()
                      : [
                          const KomentarEmptyState(),
                        ]
                  : [
                      const KomentarEmptyState(),
                    ],
        );
      }),
    );
  }

  void fetchReportedComments() {
    komunitasPostController.fetchReportedComments();
  }
}
