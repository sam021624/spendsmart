import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:spendsmart/app/themes/app_theme.dart';
import 'package:spendsmart/firebase_options.dart';
import 'package:spendsmart/views/onboarding/onboarding_screen.dart';
import 'package:spendsmart/views/home/navigation_screen.dart';
import 'package:spendsmart/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: SpendSmart()));
}

class SpendSmart extends ConsumerWidget {
  const SpendSmart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 619),
      minTextAdapt: true,
      builder: (context, child) {
        return ToastificationWrapper(
          child: MaterialApp(
            title: 'SpendSmart',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            themeMode: ThemeMode.system,
            home: authState.when(
              data: (user) {
                if (user != null) {
                  return const NavigationScreen();
                }
                return const OnboardingScreen();
              },
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => const OnboardingScreen(),
            ),
          ),
        );
      },
    );
  }
}
