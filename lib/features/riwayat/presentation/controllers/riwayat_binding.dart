import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/riwayat_repository_impl.dart';
import '../../domain/usecases/riwayat_usecase.dart';
import 'riwayat_history_controller.dart';
import 'riwayat_scan_controller.dart';

/// Binding for Riwayat controllers (RiwayatHistoryController & RiwayatScanController).
///
/// Both controllers use `lazyPut` with `fenix: true` because:
/// - They're only needed when user navigates to Riwayat feature or scans
/// - `fenix: true` ensures they're recreated if accessed after disposal
/// - Scan history should persist during the session but can be lazy-loaded
/// - Improves app startup performance by deferring initialization
class RiwayatBinding {
  final SupabaseClient client;

  RiwayatBinding({required this.client});

  void dependencies() {
    final riwayatRepository = RiwayatRepositoryImpl(client: client);
    final riwayatUsecase = RiwayatUsecase(riwayatRepository);

    // RiwayatHistoryController - manages scan history list
    Get.lazyPut<RiwayatHistoryController>(
      () => RiwayatHistoryController(riwayatUsecase),
      fenix: true,
    );

    // RiwayatScanController - manages disease scanning functionality
    Get.lazyPut<RiwayatScanController>(
      () => RiwayatScanController(riwayatUsecase),
      fenix: true,
    );
  }
}
