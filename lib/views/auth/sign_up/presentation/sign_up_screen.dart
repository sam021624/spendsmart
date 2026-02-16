import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/constants/app_sizes.dart';
import 'package:spendsmart/common/constants/icon_routes.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/common/widgets/widget_icon.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';
import 'package:spendsmart/core/helper/navigation_extension.dart';
import 'package:spendsmart/core/helper/validators.dart';
import 'package:spendsmart/core/services/auth_service.dart';
import 'package:spendsmart/views/auth/sign_up/widgets/terms_and_agreements.dart';
import 'package:spendsmart/views/home/navigation_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: AppSizes.defaultPaddingh,
              ),
              child: Column(
                spacing: 8.h,
                children: [
                  _buildImage(),
                  _buildHeader(),
                  _buildForms(),
                  _buildTermsAndAgreement(),
                  _buildButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return const WidgetIcon(imageLoc: IconRoutes.signupIcon, isSvg: true);
  }

  Widget _buildHeader() {
    return Column(
      children: [
        WidgetText(
          text: 'Sign-Up',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 4.h),
        WidgetText(
          text: 'Sign up to create an account!',
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForms() {
    return Column(
      spacing: 8.h,
      children: [
        WidgetTextField(
          controller: usernameController,
          hintText: 'Enter username',
          validator: Validators.validateUsername,
        ),
        WidgetTextField(
          controller: emailController,
          hintText: 'Enter email',
          validator: Validators.validateEmail,
        ),
        WidgetTextField(
          controller: phoneNumberController,
          hintText: 'Enter phone number',
          validator: Validators.validateEmail,
          keyboardType: TextInputType.numberWithOptions(),
        ),
        WidgetTextField(
          controller: passwordController,
          hintText: 'Enter password',
          obscureText: true,
          validator: Validators.validatePassword,
        ),
        WidgetTextField(
          controller: confirmPassController,
          hintText: 'Confirm password',
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password.';
            }
            if (value != passwordController.text) {
              return 'Passwords do not match.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsAndAgreement() {
    return TermsAndAgreement();
  }

  Widget _buildButton(BuildContext context) {
    return WidgetButton(
      text: 'Create Account',
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final user = await AuthService().signUp(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            username: usernameController.text.trim(),
            phoneNumber: phoneNumberController.text.trim(),
          );

          if (user != null) {
            context.pushAndClear(NavigationScreen());
          } else {
            // 3. Show error (e.g., email already in use)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Registration Failed. Please try again.")),
            );
          }
        }
      },
      color: AppColors.primary,
    );
  }
}
