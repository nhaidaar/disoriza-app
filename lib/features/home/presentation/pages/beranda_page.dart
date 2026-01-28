// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_avatar.dart';
import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/utils/camera.dart';
import '../../../komunitas/presentation/controllers/komunitas_controller.dart';
import '../../../komunitas/presentation/widgets/post_card.dart';
import '../../../riwayat/presentation/controllers/riwayat_history_controller.dart';
import '../../../riwayat/presentation/controllers/riwayat_scan_controller.dart';
import '../../../riwayat/presentation/widgets/riwayat_card.dart';
import '../../../auth/data/models/user_model.dart';
import '../widgets/beranda_loading_card.dart';
import '../widgets/beranda_pindai_card.dart';

class BerandaPage extends StatefulWidget {
  final UserModel user;
  final Function(int) updateIndex;
  const BerandaPage({super.key, required this.user, required this.updateIndex});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final carouselController = CarouselSliderController();
  int carouselIndex = 0;

  final komunitasController = Get.find<KomunitasController>();
  final riwayatHistoryController = Get.find<RiwayatHistoryController>();
  final riwayatScanController = Get.find<RiwayatScanController>();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    komunitasController.fetchAllPosts(max: 3);
    riwayatHistoryController.fetchRiwayat(
      uid: widget.user.id.toString(),
      max: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: context.backgroundCanvas,
        surfaceTintColor: context.backgroundCanvas,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => widget.updateIndex(3),
              child: CustomAvatar(link: widget.user.profilePicture),
            ),

            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang, ',
                  style: regularTS.copyWith(
                    fontSize: 14,
                    color: context.neutral100,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.user.name.toString(),
                  style: mediumTS.copyWith(
                    fontSize: 18,
                    color: context.neutral100,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchData(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BerandaPindaiCard(
              onTap: () async {
                final img = await pickImage(context);
                if (img != null) {
                  riwayatScanController.scanDisease(
                    uid: widget.user.id.toString(),
                    image: img,
                  );
                }
              },
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    children: [
                      Text(
                        'Diskusi petani',
                        style: mediumTS.copyWith(
                          fontSize: 18,
                          color: context.neutral100,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => widget.updateIndex(2),
                        child: Text(
                          'Lihat semua',
                          style: mediumTS.copyWith(
                            fontSize: 12,
                            color: context.neutral70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  if (komunitasController.postsStatus.value == Status.loading) {
                    return const BerandaLoadingCard();
                  } else if (komunitasController.postsStatus.value ==
                      Status.success) {
                    return komunitasController.posts.isNotEmpty
                        ? Column(
                            children: [
                              CarouselSlider(
                                carouselController: carouselController,
                                items: komunitasController.posts.map((post) {
                                  return PostCard(
                                    user: widget.user,
                                    post: post,
                                    isBerandaCard: true,
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  height: 162,
                                  viewportFraction: 0.975,
                                  initialPage: carouselIndex,
                                  onPageChanged: (index, _) {
                                    setState(() => carouselIndex = index);
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              DotsIndicator(
                                dotsCount: komunitasController.posts.length,
                                position: carouselIndex.toDouble(),
                                decorator: DotsDecorator(
                                  spacing: const EdgeInsets.all(4),
                                  color: context.neutral50,
                                  activeColor: context.accentGreen,
                                ),
                                onTap: (index) {
                                  carouselController.animateToPage(index);
                                },
                              ),
                            ],
                          )
                        : const Center(child: DiskusiEmptyState());
                  }
                  return const Center(child: DiskusiEmptyState());
                }),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: [
                      Text(
                        'Riwayat terbaru',
                        style: mediumTS.copyWith(
                          fontSize: 18,
                          color: context.neutral100,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => widget.updateIndex(1),
                        child: Text(
                          'Lihat semua',
                          style: mediumTS.copyWith(
                            fontSize: 12,
                            color: context.neutral70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  if (riwayatHistoryController.status.value == Status.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: RiwayatLoadingCard(),
                    );
                  } else if (riwayatHistoryController.status.value ==
                      Status.success) {
                    return riwayatHistoryController.riwayat.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: riwayatHistoryController.riwayat.map((
                                riwayat,
                              ) {
                                return RiwayatCard(riwayatModel: riwayat);
                              }).toList(),
                            ),
                          )
                        : const Center(child: RiwayatEmptyState());
                  }

                  return const Center(child: RiwayatEmptyState());
                }),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
