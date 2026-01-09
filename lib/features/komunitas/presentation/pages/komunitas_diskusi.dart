import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_dropdown.dart';
import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../controllers/komunitas_post_controller.dart';
import '../widgets/create_post_button.dart';
import '../widgets/post_card.dart';

class KomunitasDiskusi extends StatefulWidget {
  final UserModel user;
  const KomunitasDiskusi({super.key, required this.user});

  @override
  State<KomunitasDiskusi> createState() => _KomunitasDiskusiState();
}

class _KomunitasDiskusiState extends State<KomunitasDiskusi> {
  bool isLatest = false;
  final komunitasPostController = Get.find<KomunitasPostController>();

  @override
  void initState() {
    super.initState();
    fetchDiskusi();

    ever(komunitasPostController.postDeleted, (deleted) {
      if (deleted) {
        fetchDiskusi();
        komunitasPostController.postDeleted.value = false;
      }
    });

    ever(komunitasPostController.postCreated, (created) {
      if (created) {
        fetchDiskusi();
        komunitasPostController.postCreated.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      edgeOffset: 75,
      onRefresh: () async => fetchDiskusi(),
      child: ListView(
        children: [
          CreatePostButton(user: widget.user),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomDropdown(
                      items: const [
                        MapEntry('Terpopuler', false),
                        MapEntry('Terbaru', true),
                      ],
                      initialValue: const MapEntry('Terpopuler', false),
                      onChanged: (filter) {
                        if (isLatest != filter.value) {
                          isLatest = !isLatest;
                          komunitasPostController.fetchAllPosts(latest: isLatest);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Obx(() {
                  if (komunitasPostController.status.value == Status.loading) {
                    return const PostLoadingCard();
                  } else if (komunitasPostController.status.value == Status.success) {
                    return komunitasPostController.posts.isNotEmpty
                        ? Column(
                            children: komunitasPostController.posts.map((post) {
                              return PostCard(user: widget.user, post: post);
                            }).toList(),
                          )
                        : const DiskusiEmptyState();
                  }
                  return const DiskusiEmptyState();
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  void fetchDiskusi() {
    komunitasPostController.fetchAllPosts(latest: isLatest);
  }
}
