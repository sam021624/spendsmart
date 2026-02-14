import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendsmart/core/logic/nav_cubit.dart';
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
    return MaterialApp(
      title: 'SpendSmart',
      home: BlocBuilder<NavCubit, NavState>(
        builder: (context, state) {
          if (state is NavOnboarding) {
            return const OnboardingScreen();
          }

          return OnboardingScreen();
        },
      ),
    );
  }
}
