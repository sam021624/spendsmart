import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendsmart/core/logic/nav_cubit.dart';
import 'package:spendsmart/views/auth/sign_in/presentation/sign_in_screen.dart';
import 'package:spendsmart/views/onboarding/onboarding_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => NavCubit())],
      child: const SpendSmart(),
    ),
  );
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
        home: BlocBuilder<NavCubit, NavState>(
          builder: (context, state) {
            if (state is NavOnboarding) {
              return const OnboardingScreen();
            } else if (state is NavSignIn) {
              return const SignInScreen();
            }
            return OnboardingScreen();
          },
        ),
      ),
    );
  }
}
