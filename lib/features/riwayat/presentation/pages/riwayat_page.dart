import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/common/custom_textfield.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../controllers/riwayat_history_controller.dart';
import '../widgets/riwayat_card.dart';

class RiwayatPage extends StatefulWidget {
  final UserModel user;
  const RiwayatPage({super.key, required this.user});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final _searchController = TextEditingController();
  final riwayatHistoryController = Get.find<RiwayatHistoryController>();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchRiwayats();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchRiwayats() {
    riwayatHistoryController.fetchRiwayat(uid: widget.user.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 128,
        backgroundColor: neutral10,
        surfaceTintColor: neutral10,
        shape: const Border(
          bottom: BorderSide(color: neutral30),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Riwayat pemindaian',
              style: mediumTS.copyWith(color: neutral100),
            ),
            const SizedBox(height: 16),
            CustomFormField(
              controller: _searchController,
              hint: 'Cari judul penyakit',
              backgroundColor: backgroundCanvas,
              prefixIcon: IconsaxPlusLinear.search_normal,
              prefixIconColor: neutral60,
              onChanged: (value) {
                Timer(Durations.extralong1, () {
                  setState(() => _searchQuery = value);
                });
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchRiwayats();
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Obx(() {
              if (riwayatHistoryController.status.value == Status.loading) {
                return const RiwayatLoadingCard();
              } else if (riwayatHistoryController.status.value == Status.success) {
                final filteredList = riwayatHistoryController.riwayat.where((riwayat) {
                  final title = riwayat.idDisease?.name?.toLowerCase() ?? '';
                  return title.contains(_searchQuery.toLowerCase());
                }).toList();

                if (filteredList.isNotEmpty) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: filteredList.map((riwayat) {
                      return RiwayatCard(riwayatModel: riwayat);
                    }).toList(),
                  );
                }
                return const Center(child: RiwayatEmptyState());
              }
              return const Center(child: RiwayatEmptyState());
            }),
          ],
        ),
      ),
    );
  }
}
