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
import 'package:spendsmart/views/auth/forgot_password/forgot_password_screen.dart';
import 'package:spendsmart/views/auth/sign_up/presentation/sign_up_screen.dart';
import 'package:spendsmart/views/home/navigation_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final bool _isLoading = false;
  bool _rememberMe = false;

  // static const String _rememberMeKey = 'rememberMe';
  // static const String _emailKey = 'savedEmail';
  // static const String _passwordKey = 'savedPassword';

  Future<void> submitLogin(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      context.pushReplace(const NavigationScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.defaultPaddingh),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16.sp,
                children: [
                  _buildImage(),
                  _buildHeader(),
                  _buildForms(),
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
    return const WidgetIcon(imageLoc: IconRoutes.loginIcon, isSvg: true);
  }

  Widget _buildHeader() {
    return Column(
      children: [
        WidgetText(
          text: 'Sign-In',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 4.h),
        WidgetText(
          text: 'Sign in to save your progress and track your expenses today!',
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForms() {
    return Column(
      children: [
        WidgetTextField(
          controller: emailController,
          hintText: 'Enter email',
          validator: Validators.validateEmail,
        ),
        SizedBox(height: 8.sp),
        WidgetTextField(
          controller: passwordController,
          hintText: 'Enter password',
          obscureText: true,
          validator: Validators.validatePassword,
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _rememberMe = newValue ?? false;
                    });
                  },
                  activeColor: AppColors.primary,
                ),
                WidgetText(text: 'Remember me', fontSize: 12.sp),
              ],
            ),
            GestureDetector(
              // onTap: () => context.read<NavCubit>().showForgotPassword(),
              onTap: () => context.navigateTo(const ForgotPasswordScreen()),
              child: WidgetText(
                text: 'Forgot Password',
                textColor: AppColors.primary,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return Column(
      children: [
        WidgetButton(
          text: _isLoading ? 'Signing In...' : 'Sign in',
          textColor: Colors.white,
          onPressed: _isLoading ? null : () => submitLogin(context),
          color: AppColors.primary,
        ),
        SizedBox(height: 8.h),
        WidgetButton(
          text: 'Create Account',
          textColor: Colors.black,
          onPressed: () => context.navigateTo(const SignUpScreen()),
          color: Colors.white,
        ),
      ],
    );
  }
}
