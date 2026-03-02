import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/constants/app_sizes.dart';
import 'package:spendsmart/common/constants/icon_routes.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/common/widgets/widget_icon.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';
import 'package:spendsmart/common/widgets/widget_snackbar.dart';
import 'package:spendsmart/core/helper/navigation_extension.dart';
import 'package:spendsmart/core/helper/validators.dart';
import 'package:spendsmart/core/services/auth_service.dart';
import 'package:spendsmart/views/auth/forgot_password/forgot_password_screen.dart';
import 'package:spendsmart/views/auth/sign_up/presentation/sign_up_screen.dart';
import 'package:spendsmart/views/home/navigation_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;

  static const String _rememberMeKey = 'rememberMe';
  static const String _emailKey = 'savedEmail';
  static const String _passwordKey = 'savedPassword';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool(_rememberMeKey) ?? false;
      if (_rememberMe) {
        emailController.text = prefs.getString(_emailKey) ?? '';
        passwordController.text = prefs.getString(_passwordKey) ?? '';
      }
    });
  }

  Future<void> _saveOrClearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setBool(_rememberMeKey, true);
      await prefs.setString(_emailKey, emailController.text.trim());
      await prefs.setString(_passwordKey, passwordController.text.trim());
    } else {
      await prefs.setBool(_rememberMeKey, false);
      await prefs.remove(_emailKey);
      await prefs.remove(_passwordKey);
    }
  }

  Future<void> submitLogin(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final user = await AuthService().login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        await _saveOrClearCredentials();
        if (mounted) {
          WidgetSnackbar.showSuccess(
            context: context,
            title: "Welcome Back!",
            message: "You have successfully signed in.",
          );
          context.pushAndClear(const NavigationScreen());
        }
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          WidgetSnackbar.showError(
            context: context,
            title: "Login Failed",
            message: "Please check your credentials and try again.",
          );
        }
      }
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
                spacing: 8.h,
                children: [
                  const WidgetIcon(imageLoc: IconRoutes.loginIcon, isSvg: true),
                  _buildHeader(),
                  _buildForms(),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        WidgetText(
          text: 'Sign-In',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 8.h),
        WidgetText(
          text: 'Sign in to save your progress and track your expenses today!',
          fontSize: 12.sp,
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
        SizedBox(height: 8.h),
        WidgetTextField(
          controller: passwordController,
          hintText: 'Enter password',
          obscureText: true,
          validator: Validators.validatePassword,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _rememberMe = val!),
                ),
                WidgetText(text: 'Remember me', fontSize: 12.sp),
              ],
            ),
            GestureDetector(
              onTap: () => context.navigateTo(const ForgotPasswordScreen()),
              child: WidgetText(
                text: 'Forgot Password?',
                textColor: AppColors.primary,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        WidgetButton(
          text: _isLoading ? 'Signing In...' : 'Sign In',
          onPressed: _isLoading ? null : () => submitLogin(context),
          color: AppColors.primary,
          textColor: Colors.white,
        ),
        SizedBox(height: 8.h),
        WidgetButton(
          text: 'Create Account',
          onPressed: () => context.navigateTo(const SignUpScreen()),
          color: Colors.white,
          textColor: Colors.black,
        ),
      ],
    );
  }
}
