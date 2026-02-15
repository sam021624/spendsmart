import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/constants/app_sizes.dart';
import 'package:spendsmart/common/constants/icon_routes.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/core/helper/navigation_extension.dart';
import 'package:spendsmart/views/auth/sign_in/presentation/sign_in_screen.dart';
import 'package:spendsmart/views/onboarding/cubit/onboarding_cubit.dart';
import 'package:spendsmart/views/onboarding/widgets/carousel_item.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

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
        return 'Manage Expenses';
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
        return 'Turn your savings dream into reality with personalized financial coaching.';
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.defaultPaddingh,
              vertical: AppSizes.defaultPaddingw,
            ),
            child: Column(
              spacing: 8.h,
              children: [
                _buildCarouselImage(context),
                _buildIndicator(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        height: 230.h,
        viewportFraction: 1.0,
        autoPlay: true,
        onPageChanged: (index, reason) {
          context.read<OnboardingCubit>().updatePage(index);
        },
      ),
    );
  }

  Widget _buildIndicator(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, activeIndex) {
        return AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: 3,

          effect: WormEffect(
            dotWidth: 8,
            dotHeight: 8,
            dotColor: AppColors.primary.withAlpha(50),
            activeDotColor: AppColors.primary,
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: AppSizes.defaultPaddingh,
      ),
      child: WidgetButton(
        text: 'Get Started',
        onPressed: () => context.navigateTo(const SignInScreen()),
      ),
    );
  }
}
