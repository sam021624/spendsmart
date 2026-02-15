import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendsmart/app/themes/app_theme.dart';
import 'package:spendsmart/views/onboarding/onboarding_screen.dart';

void main() {
  runApp(const SpendSmart());
}

class SpendSmart extends StatelessWidget {
  const SpendSmart({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 619),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'SpendSmart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        themeMode: ThemeMode.system,
        home: const OnboardingScreen(),
      ),
    );
  }
}
