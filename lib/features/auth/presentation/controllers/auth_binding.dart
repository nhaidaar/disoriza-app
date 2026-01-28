import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/auth_usecase.dart';
import 'auth_controller.dart';

/// Binding for AuthController.
///
/// AuthController uses `put` with `permanent: true` because:
/// - It manages user session state that must persist across the entire app lifecycle
/// - It needs to be available immediately on app start for authentication checks
/// - Session loss would cause critical UX issues (unexpected logouts)
class AuthBinding {
  final SupabaseClient client;

  AuthBinding({required this.client});

  void dependencies() {
    final authRepository = AuthRepositoryImpl(client: client);
    final authUsecase = AuthUsecase(authRepository);

    Get.put<AuthController>(
      AuthController(authUsecase),
      permanent: true,
    );
  }

  /// Returns the AuthUsecase for use by other bindings (e.g., SetelanBinding)
  AuthUsecase getAuthUsecase() {
    final authRepository = AuthRepositoryImpl(client: client);
    return AuthUsecase(authRepository);
  }
}
