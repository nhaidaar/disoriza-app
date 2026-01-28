import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/auth_usecase.dart';
import 'setelan_controller.dart';

/// Binding for SetelanController.
///
/// SetelanController uses `lazyPut` with `fenix: true` because:
/// - It's only needed when user navigates to Settings
/// - `fenix: true` ensures it's recreated if accessed after disposal
/// - Settings state can be lazy-loaded when needed
/// - Improves app startup performance
///
/// Note: SetelanController depends on AuthUsecase for profile management
class SetelanBinding {
  final SupabaseClient client;

  SetelanBinding({required this.client});

  void dependencies() {
    final authRepository = AuthRepositoryImpl(client: client);
    final authUsecase = AuthUsecase(authRepository);

    Get.lazyPut<SetelanController>(
      () => SetelanController(authUsecase),
      fenix: true,
    );
  }
}
