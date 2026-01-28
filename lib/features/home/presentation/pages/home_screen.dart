// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/utils/camera.dart';
import '../../../../core/utils/dialog.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../riwayat/presentation/controllers/riwayat_history_controller.dart';
import '../../../riwayat/presentation/controllers/riwayat_scan_controller.dart';
import '../../../riwayat/presentation/pages/riwayat_detail.dart';
import '../../../riwayat/presentation/pages/riwayat_page.dart';
import '../../../komunitas/presentation/pages/komunitas_page.dart';
import '../../../setelan/presentation/pages/setelan_page.dart';
import 'beranda_page.dart';

class HomeScreen extends StatefulWidget {
  final SupabaseClient client;
  final UserModel user;
  const HomeScreen({super.key, required this.client, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final riwayatHistoryController = Get.find<RiwayatHistoryController>();
  final riwayatScanController = Get.find<RiwayatScanController>();

  Worker? _riwayatDeletedWorker;
  Worker? _historyStatusWorker;
  Worker? _scanStatusWorker;

  void updateIndex(int newIndex) {
    setState(() => _selectedIndex = newIndex);
  }

  void fetchRiwayats() {
    riwayatHistoryController.fetchRiwayat(
      uid: widget.user.id.toString(),
      max: _selectedIndex == 0 ? 4 : null,
    );
  }

  @override
  void initState() {
    super.initState();
    _riwayatDeletedWorker = ever(riwayatHistoryController.riwayatDeleted, (deleted) {
      if (deleted) {
        handleRiwayatDeleted(context);
        riwayatHistoryController.riwayatDeleted.value = false;
      }
    });

    _historyStatusWorker = ever(riwayatHistoryController.status, (status) {
      if (status == Status.error &&
          riwayatHistoryController.errorMessage.value.isNotEmpty) {
        showSnackbar(
          context,
          message: riwayatHistoryController.errorMessage.value,
          isError: true,
        );
        riwayatHistoryController.errorMessage.value = '';
      }
    });

    _scanStatusWorker = ever(riwayatScanController.status, (status) {
      if (status == Status.loading) {
        showDiseaseLoading(context);
      } else if (status == Status.error &&
          riwayatScanController.errorMessage.value.isNotEmpty) {
        Navigator.of(context).pop();
        showDiseaseError(
          context,
          message: riwayatScanController.errorMessage.value,
          onScan: () {
            Navigator.of(context).pop();
            handleScanDisease(context);
          },
        );
        riwayatScanController.errorMessage.value = '';
      } else if (status == Status.success) {
        Navigator.of(context).pop();
        handleDiseaseSuccess(context);
      }
    });
  }

  @override
  void dispose() {
    _riwayatDeletedWorker?.dispose();
    _historyStatusWorker?.dispose();
    _scanStatusWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BerandaPage(user: widget.user, updateIndex: updateIndex),
      RiwayatPage(user: widget.user),
      KomunitasPage(user: widget.user),
      SetelanPage(user: widget.user),
    ];

    return Scaffold(
      body: pages[_selectedIndex],

      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.neutral10,
          border: Border(top: BorderSide(color: context.neutral30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavItem(
              icon: IconsaxPlusLinear.home_2,
              activeIcon: IconsaxPlusBold.home_2,
              title: 'Beranda',
              selected: _selectedIndex == 0,
              onTap: () {
                if (_selectedIndex != 0) updateIndex(0);
              },
            ),

            NavItem(
              icon: IconsaxPlusLinear.clipboard_text,
              activeIcon: IconsaxPlusBold.clipboard_text,
              title: 'Riwayat',
              selected: _selectedIndex == 1,
              onTap: () {
                if (_selectedIndex != 1) updateIndex(1);
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: GestureDetector(
                onTap: () async => await handleScanDisease(context),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: accentOrangeMain,
                  child: Icon(IconsaxPlusBold.scan, color: context.neutral10),
                ),
              ),
            ),

            NavItem(
              icon: IconsaxPlusLinear.story,
              activeIcon: IconsaxPlusBold.story,
              title: 'Komunitas',
              selected: _selectedIndex == 2,
              onTap: () {
                if (_selectedIndex != 2) updateIndex(2);
              },
            ),

            NavItem(
              icon: IconsaxPlusLinear.setting,
              activeIcon: IconsaxPlusBold.setting,
              title: 'Setelan',
              selected: _selectedIndex == 3,
              onTap: () {
                if (_selectedIndex != 3) updateIndex(3);
              },
            ),
          ],
        ),
      ),
    );
  }

  void handleRiwayatDeleted(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    showSnackbar(context, message: 'Riwayat berhasil dihapus');
    fetchRiwayats();
  }

  void handleDiseaseSuccess(BuildContext context) {
    final riwayatModel = riwayatScanController.latestScan.value;
    riwayatModel != null
        ? Get.to(
            () => RiwayatDetail(riwayat: riwayatModel),
          )?.then((_) => fetchRiwayats())
        : showDiseaseSehat(
            context,
            onScan: () {
              Navigator.of(context).pop();
              handleScanDisease(context);
            },
          );
  }

  Future<void> handleScanDisease(BuildContext context) async {
    final img = await pickImage(context);
    if (img != null) {
      riwayatScanController.scanDisease(
        uid: widget.user.id.toString(),
        image: img,
      );
    }
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool selected;
  final String title;
  final Function()? onTap;
  const NavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.selected,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Icon(
              selected ? activeIcon : icon,
              color: selected ? context.accentGreen : context.neutral70,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: mediumTS.copyWith(
                fontSize: 12,
                color: selected ? context.accentGreen : context.neutral70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
