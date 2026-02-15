import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/constants/app_sizes.dart';
import 'package:spendsmart/common/constants/icon_routes.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/core/logic/nav_cubit.dart';
import 'package:spendsmart/views/onboarding/cubit/onboarding_cubit.dart';
import 'package:spendsmart/views/onboarding/widgets/carousel_item.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  String _getImageForIndex(int index) {
    switch (index) {
      case 0:
        return IconRoutes.onboardingOne;
      case 1:
        return IconRoutes.onboardingTwo;
      case 2:
        return IconRoutes.onboardingThree;
      default:
        return IconRoutes.onboardingOne;
    }
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Tipid-Grocery Finds';
      case 1:
        return 'Fast, Easy Checkout';
      case 2:
        return 'Quick & Easy Delivery';
      default:
        return 'Tipid-Grocery Finds';
    }
  }

  String _getDescriptionForIndex(int index) {
    switch (index) {
      case 0:
        return 'Discover exclusive deals and discounts from your favorite local stores';
      case 1:
        return 'Complete your purchases and payment in seconds with a few quick taps on your phone.';
      case 2:
        return 'Enjoy fast service, tailored to your schedule.';
      default:
        return 'Discover exclusive deals and discounts from your favorite local stores';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: AppSizes.defaultPaddingw,
                    vertical: AppSizes.defaultPaddingh,
                  ),
                  child: Column(
                    children: [_buildCarouselImage(context), _buildIndicator()],
                  ),
                ),
              ),
            ),
            floatingActionButton: _buildButton(context),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }

  Widget _buildCarouselImage(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: 3,
      itemBuilder: (context, index, realIdx) {
        return CarouselItem(
          image: _getImageForIndex(index),
          title: _getTitleForIndex(index),
          description: _getDescriptionForIndex(index),
        );
      },
      options: CarouselOptions(
        height: 350,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          context.read<OnboardingCubit>().updatePage(index);
        },
      ),
    );
  }

  Widget _buildIndicator() {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, activeIndex) {
        return AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: 3,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: AppColors.primary,
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 0),
      child: WidgetButton(
        text: 'Get Started',
        width: 400,
        onPressed: () => context.read<NavCubit>().showSignIn(),
      ),
    );
  }
}
