import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/constants/app_sizes.dart';
import 'package:spendsmart/common/constants/icon_routes.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/common/widgets/widget_icon.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';
import 'package:spendsmart/core/helper/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.defaultPaddingh,
            vertical: AppSizes.defaultPaddingh,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 8.h,
              children: [_buildImage(), _buildHeader(), _buildForms()],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImage() {
    return const WidgetIcon(
      imageLoc: IconRoutes.forgotPasswordIcon,
      isSvg: true,
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        WidgetText(
          text: 'Forgot Password?',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 4.h),
        WidgetText(
          text:
              "We all have times like this! Let's get you back into your account",
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForms() {
    return WidgetTextField(
      controller: emailController,
      hintText: 'Enter email',
      validator: Validators.validateEmail,
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: AppSizes.defaultPaddingh,
      ),
      child: WidgetButton(
        text: _isLoading ? 'Submitting...' : 'Submit',
        textColor: Colors.white,
        onPressed: () {},
        color: AppColors.primary,
      ),
    );
  }
}
