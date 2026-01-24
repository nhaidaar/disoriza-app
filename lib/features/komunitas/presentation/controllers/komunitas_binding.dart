import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/komunitas_repository_impl.dart';
import '../../domain/usecases/komunitas_usecase.dart';
import 'komunitas_controller.dart';

/// Binding for KomunitasController.
///
/// KomunitasController uses `lazyPut` because:
/// - It's only needed when user navigates to the Komunitas feature
/// - State should be fresh each time (no permanent flag)
/// - Lazy initialization improves app startup performance
/// - Memory is freed when not in use
class KomunitasBinding {
  final SupabaseClient client;

  KomunitasBinding({required this.client});

  void dependencies() {
    final komunitasRepository = KomunitasRepositoryImpl(client: client);
    final komunitasUsecase = KomunitasUsecase(komunitasRepository);

    Get.lazyPut<KomunitasController>(
      () => KomunitasController(komunitasUsecase),
      fenix: true, // Recreate if disposed and accessed again
    );
  }
}
