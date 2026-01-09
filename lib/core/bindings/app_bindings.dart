import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/auth_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/komunitas/data/repositories/komunitas_repository_impl.dart';
import '../../features/komunitas/domain/usecases/komunitas_usecase.dart';
import '../../features/komunitas/presentation/controllers/komunitas_comment_controller.dart';
import '../../features/komunitas/presentation/controllers/komunitas_post_controller.dart';
import '../../features/komunitas/presentation/controllers/komunitas_report_controller.dart';
import '../../features/komunitas/presentation/controllers/komunitas_search_controller.dart';
import '../../features/riwayat/data/repositories/riwayat_repository_impl.dart';
import '../../features/riwayat/domain/usecases/riwayat_usecase.dart';
import '../../features/riwayat/presentation/controllers/riwayat_history_controller.dart';
import '../../features/riwayat/presentation/controllers/riwayat_scan_controller.dart';
import '../../features/setelan/presentation/controllers/setelan_controller.dart';

class AppBindings extends Bindings {
  final SupabaseClient client;

  AppBindings({required this.client});

  @override
  void dependencies() {
    final authRepository = AuthRepositoryImpl(client: client);
    final authUsecase = AuthUsecase(authRepository);

    final komunitasRepository = KomunitasRepositoryImpl(client: client);
    final komunitasUsecase = KomunitasUsecase(komunitasRepository);

    final riwayatRepository = RiwayatRepositoryImpl(client: client);
    final riwayatUsecase = RiwayatUsecase(riwayatRepository);

    Get.put<AuthController>(AuthController(authUsecase));
    Get.put<KomunitasPostController>(
      KomunitasPostController(komunitasUsecase),
      permanent: true,
    );
    Get.put<KomunitasCommentController>(
      KomunitasCommentController(komunitasUsecase),
      permanent: true,
    );
    Get.put<KomunitasSearchController>(
      KomunitasSearchController(komunitasUsecase),
      permanent: true,
    );
    Get.put<KomunitasReportController>(
      KomunitasReportController(komunitasUsecase),
      permanent: true,
    );
    Get.put<RiwayatHistoryController>(RiwayatHistoryController(riwayatUsecase));
    Get.put<RiwayatScanController>(RiwayatScanController(riwayatUsecase));
    Get.put<SetelanController>(SetelanController(authUsecase));
  }
}
