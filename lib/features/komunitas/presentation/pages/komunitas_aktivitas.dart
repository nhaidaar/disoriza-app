import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../controllers/komunitas_post_controller.dart';
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
  final komunitasPostController = Get.find<KomunitasPostController>();

  final aktivitasCategory = [
    'Postingan',
    'Disukai',
    'Komentar',
    'Dilaporkan',
  ];

  @override
  void initState() {
    super.initState();
    fetchAktivitas();

    ever(komunitasPostController.postDeleted, (deleted) {
      if (deleted) {
        fetchAktivitas();
        komunitasPostController.postDeleted.value = false;
      }
    });
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
                      komunitasPostController.fetchAktivitas(
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
            onRefresh: () async => komunitasPostController.fetchAktivitas(
              uid: widget.user.id.toString(),
              filter: aktivitasCategory[_selectedIndex],
            ),
            displacement: 10,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                Obx(() {
                  if (komunitasPostController.status.value == Status.loading) {
                    return const PostLoadingCard();
                  } else if (komunitasPostController.status.value == Status.success) {
                    return komunitasPostController.posts.isNotEmpty
                        ? Column(
                            children: komunitasPostController.posts.map((post) {
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
    komunitasPostController.fetchAktivitas(
      uid: widget.user.id.toString(),
      filter: aktivitasCategory[_selectedIndex],
    );
  }
}
