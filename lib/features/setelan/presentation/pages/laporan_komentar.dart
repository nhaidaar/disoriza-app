import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../komunitas/presentation/controllers/komunitas_controller.dart';
import '../../../komunitas/presentation/widgets/post_card.dart';
import '../../../komunitas/presentation/widgets/reported_comment_card.dart';

class LaporanKomentar extends StatefulWidget {
  final UserModel user;
  const LaporanKomentar({super.key, required this.user});

  @override
  State<LaporanKomentar> createState() => _LaporanKomentarState();
}

class _LaporanKomentarState extends State<LaporanKomentar> {
  final komunitasController = Get.find<KomunitasController>();

  @override
  void initState() {
    super.initState();
    fetchReportedComments();

    ever(komunitasController.commentDeleted, (deleted) {
      if (deleted) {
        fetchReportedComments();
        komunitasController.commentDeleted.value = false;
      }
    });

    ever(komunitasController.postDeleted, (deleted) {
      if (deleted) {
        fetchReportedComments();
        komunitasController.postDeleted.value = false;
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
          children: komunitasController.commentsStatus.value == Status.loading
              ? [
                  const PostLoadingCard(),
                ]
              : komunitasController.commentsStatus.value == Status.success
                  ? komunitasController.reportedComments.isNotEmpty
                      ? komunitasController.reportedComments.map((model) {
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
    komunitasController.fetchReportedComments();
  }
}
