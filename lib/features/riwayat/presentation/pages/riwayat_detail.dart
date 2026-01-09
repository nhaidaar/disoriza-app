// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_popup.dart';
import '../../../../core/common/effects.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/utils/camera.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/utils/network_image.dart';
import '../../../home/presentation/widgets/disoriza_logo.dart';
import '../../data/models/riwayat_model.dart';
import '../controllers/riwayat_history_controller.dart';
import '../controllers/riwayat_scan_controller.dart';
import '../widgets/riwayat_detail_card.dart';
import '../widgets/riwayat_detail_remote.dart';

class RiwayatDetail extends StatefulWidget {
  final RiwayatModel riwayat;
  const RiwayatDetail({super.key, required this.riwayat});

  @override
  State<RiwayatDetail> createState() => _RiwayatDetailState();
}

class _RiwayatDetailState extends State<RiwayatDetail> {
  final _scrollController = AutoScrollController();
  final riwayatHistoryController = Get.find<RiwayatHistoryController>();
  final riwayatScanController = Get.find<RiwayatScanController>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: neutral10,
        surfaceTintColor: neutral10,
        shape: const Border(
          bottom: BorderSide(color: neutral30),
        ),

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(IconsaxPlusLinear.arrow_left),
        ),

        title: const DisorizaLogo(),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () => handleDeleteRiwayat(context),
            icon: const Icon(IconsaxPlusLinear.trash, color: dangerMain),
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        children: [
          Container(
            height: 380,
            decoration: BoxDecoration(
              borderRadius: defaultSmoothRadius,
              image: DecorationImage(
                image: getImageProvider(widget.riwayat.urlImage.toString()),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: defaultSmoothRadius,
                    color: neutral10,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jenis penyakit',
                            style: mediumTS.copyWith(color: neutral70),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.riwayat.idDisease!.name.toString(),
                            style: mediumTS.copyWith(fontSize: 18, color: neutral100),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final img = await pickImage(context);
                          if (img != null) {
                            riwayatScanController.scanDisease(
                              uid: widget.riwayat.idUser.toString(),
                              image: img,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            IconsaxPlusBold.scan,
                            color: neutral10,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                flex: 5,
                child: RiwayatDetailCard(
                  index: -1,
                  controller: _scrollController,
                  title: 'Dipindai pada',
                  content: formatDate(widget.riwayat.date),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                flex: 4,
                child: RiwayatDetailCard(
                  index: -1,
                  controller: _scrollController,
                  title: 'Akurasi',
                  content: '${((widget.riwayat.accuracy ?? 0) * 100).toStringAsFixed(2)} %',
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          RiwayatDetailCard(
            index: 0,
            controller: _scrollController,
            title: 'Definisi',
            content: widget.riwayat.idDisease!.definition.toString(),
          ),

          const SizedBox(height: 8),

          RiwayatDetailCard(
            index: 1,
            controller: _scrollController,
            title: 'Gejala',
            content: widget.riwayat.idDisease!.symtomp.toString(),
          ),

          const SizedBox(height: 8),

          RiwayatDetailCard(
            index: 2,
            controller: _scrollController,
            title: 'Solusi',
            content: widget.riwayat.idDisease!.solution.toString(),
          ),

          const SizedBox(height: 150),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          border: Border.all(color: neutral30),
          color: neutral10,
          boxShadow: const [shadowEffect1],
        ),
        child: Row(
          children: [
            RiwayatDetailRemote(
              title: 'Definisi',
              isActive: _currentIndex == 0,
              onTap: () => _scrollToIndex(0),
            ),
            const SizedBox(width: 4),
            RiwayatDetailRemote(
              title: 'Gejala',
              isActive: _currentIndex == 1,
              onTap: () => _scrollToIndex(1),
            ),
            const SizedBox(width: 4),
            RiwayatDetailRemote(
              title: 'Solusi',
              isActive: _currentIndex == 2,
              onTap: () => _scrollToIndex(2),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleDeleteRiwayat(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => CustomPopup(
        icon: IconsaxPlusLinear.trash,
        iconColor: dangerMain,
        title: 'Ingin menghapus riwayat ini?',
        subtitle: 'Setelah dihapus, data tidak dapat diurungkan.',
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  backgroundColor: dangerMain,
                  pressedColor: dangerPressed,
                  onTap: () => riwayatHistoryController.deleteRiwayat(riwayatId: widget.riwayat.id.toString()),
                  text: 'Ya, hapus',
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomButton(
                  backgroundColor: neutral10,
                  pressedColor: neutral50,
                  onTap: () => Navigator.of(context).pop(),
                  text: 'Batal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    final double viewportHeight = _scrollController.position.viewportDimension;
    final double screenTriggerOffset = viewportHeight * 0.3;

    for (int i = 0; i < 3; i++) {
      final RenderObject? renderObject = _scrollController.tagMap[i]?.context.findRenderObject();

      if (renderObject is RenderBox) {
        final position = renderObject.localToGlobal(Offset.zero);
        final itemOffset = position.dy - _scrollController.offset;

        if (itemOffset <= screenTriggerOffset) {
          if (i == 2 ||
              (_scrollController.tagMap[i + 1]?.context.findRenderObject() as RenderBox?)!
                      .localToGlobal(Offset.zero)
                      .dy >
                  screenTriggerOffset) {
            if (_currentIndex != i) {
              setState(() => _currentIndex = i);
            }
            break;
          }
        }
      }
    }
  }

  Future _scrollToIndex(int index) async {
    final double viewportHeight = _scrollController.position.viewportDimension;
    final double offset = viewportHeight * 0.15;

    await _scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);

    final targetContext = _scrollController.tagMap[index]?.context;
    if (targetContext != null) {
      final RenderObject? renderObject = targetContext.findRenderObject();
      if (renderObject is RenderBox) {
        final position = renderObject.localToGlobal(Offset.zero);
        final scrollOffset = _scrollController.offset + position.dy - offset;

        await _scrollController.animateTo(
          scrollOffset,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }

    setState(() => _currentIndex = index);
  }
}
