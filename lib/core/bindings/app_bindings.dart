import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/controllers/auth_binding.dart';
import '../../features/komunitas/presentation/controllers/komunitas_binding.dart';
import '../../features/riwayat/presentation/controllers/riwayat_binding.dart';
import '../../features/setelan/presentation/controllers/setelan_binding.dart';

/// Main application bindings that orchestrates all feature bindings.
///
/// This class delegates dependency injection to individual feature bindings,
/// promoting separation of concerns and making each feature self-contained.
///
/// Binding Strategy:
/// - AuthBinding: Uses `put` with `permanent: true` (session must persist)
/// - KomunitasBinding: Uses `lazyPut` with `fenix: true` (lazy, recreatable)
/// - RiwayatBinding: Uses `lazyPut` with `fenix: true` (lazy, recreatable)
/// - SetelanBinding: Uses `lazyPut` with `fenix: true` (lazy, recreatable)
class AppBindings extends Bindings {
  final SupabaseClient client;

  AppBindings({required this.client});

  @override
  void dependencies() {
    // Auth - must be initialized first and persist throughout app lifecycle
    AuthBinding(client: client).dependencies();

    // Feature bindings - lazy loaded when needed
    KomunitasBinding(client: client).dependencies();
    RiwayatBinding(client: client).dependencies();
    SetelanBinding(client: client).dependencies();
  }
}
