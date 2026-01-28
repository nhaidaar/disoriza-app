import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_dropdown.dart';
import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../controllers/komunitas_controller.dart';
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
  final komunitasController = Get.find<KomunitasController>();
  final List<Worker> _workers = [];

  @override
  void initState() {
    super.initState();

    // Defer fetch to after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDiskusi();
    });

    _workers.add(ever(komunitasController.postDeleted, (deleted) {
      if (deleted) {
        fetchDiskusi();
        komunitasController.postDeleted.value = false;
      }
    }));

    _workers.add(ever(komunitasController.postCreated, (created) {
      if (created) {
        fetchDiskusi();
        komunitasController.postCreated.value = false;
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
                          komunitasController.fetchAllPosts(latest: isLatest);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Obx(() {
                  if (komunitasController.postsStatus.value == Status.loading) {
                    return const PostLoadingCard();
                  } else if (komunitasController.postsStatus.value == Status.success) {
                    return komunitasController.posts.isNotEmpty
                        ? Column(
                            children: komunitasController.posts.map((post) {
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
    komunitasController.fetchAllPosts(latest: isLatest);
  }
}
