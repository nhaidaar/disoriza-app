import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import 'core/bindings/app_bindings.dart';
import 'core/enums/status.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/utils/snackbar.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/home/presentation/pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final supabase = await supa.Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  runApp(Disoriza(client: supabase.client));
}

class Disoriza extends StatelessWidget {
  final supa.SupabaseClient client;
  const Disoriza({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Disoriza',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: AppBindings(client: client),
      home: _ThemeWrapper(client: client),
    );
  }
}

/// Wrapper that listens to theme changes and rebuilds the app.
class _ThemeWrapper extends StatelessWidget {
  final supa.SupabaseClient client;
  const _ThemeWrapper({required this.client});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      // This triggers rebuild when theme changes
      final _ = themeController.themeMode.value;
      return _AuthWrapper(client: client);
    });
  }
}

class _AuthWrapper extends StatefulWidget {
  final supa.SupabaseClient client;
  const _AuthWrapper({required this.client});

  @override
  State<_AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<_AuthWrapper> {
  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().checkSession();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      if (authController.status.value == Status.error && authController.errorMessage.value.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showSnackbar(context, message: authController.errorMessage.value, isError: true);
          authController.errorMessage.value = '';
        });
      }

      if (authController.status.value == Status.initial) {
        return const SplashScreen();
      } else if (authController.status.value == Status.success && authController.user.value != null) {
        return HomeScreen(
          client: widget.client,
          user: authController.user.value!,
        );
      }
      return const AuthPage();
    });
  }
}
