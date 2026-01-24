import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../controllers/komunitas_controller.dart';
import '../widgets/aktivitasmu_category.dart';
import '../widgets/post_card.dart';

class KomunitasAktivitas extends StatefulWidget {
  final UserModel user;
  const KomunitasAktivitas({super.key, required this.user});

  @override
  State<KomunitasAktivitas> createState() => _KomunitasAktivitasState();
}

class _KomunitasAktivitasState extends State<KomunitasAktivitas> {
  int _selectedIndex = 0;
  final komunitasController = Get.find<KomunitasController>();
  final List<Worker> _workers = [];

  final aktivitasCategory = [
    'Postingan',
    'Disukai',
    'Komentar',
    'Dilaporkan',
  ];

  @override
  void initState() {
    super.initState();

    // Defer fetch to after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAktivitas();
    });

    _workers.add(ever(komunitasController.postDeleted, (deleted) {
      if (deleted) {
        fetchAktivitas();
        komunitasController.postDeleted.value = false;
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
    return Column(
      children: [
        const SizedBox(height: 8),

        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: aktivitasCategory.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 8 : 0,
                  right: index == aktivitasCategory.length - 1 ? 4 : 0,
                ),
                child: AktivitasmuCategory(
                  onTap: () => setState(() {
                    if (_selectedIndex != index) {
                      _selectedIndex = index;
                      komunitasController.fetchAktivitas(
                        uid: widget.user.id.toString(),
                        filter: aktivitasCategory[_selectedIndex],
                      );
                    }
                  }),
                  title: aktivitasCategory[index],
                  isSelected: _selectedIndex == index,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => komunitasController.fetchAktivitas(
              uid: widget.user.id.toString(),
              filter: aktivitasCategory[_selectedIndex],
            ),
            displacement: 10,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                Obx(() {
                  if (komunitasController.postsStatus.value == Status.loading) {
                    return const PostLoadingCard();
                  } else if (komunitasController.postsStatus.value == Status.success) {
                    return komunitasController.posts.isNotEmpty
                        ? Column(
                            children: komunitasController.posts.map((post) {
                              return PostCard(
                                user: widget.user,
                                post: post,
                                isAktivitas: true,
                              );
                            }).toList(),
                          )
                        : const AktivitasEmptyState();
                  }
                  return const AktivitasEmptyState();
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void fetchAktivitas() {
    komunitasController.fetchAktivitas(
      uid: widget.user.id.toString(),
      filter: aktivitasCategory[_selectedIndex],
    );
  }
}
