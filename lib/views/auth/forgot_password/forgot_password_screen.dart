import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/constants/app_sizes.dart';
import 'package:spendsmart/common/constants/icon_routes.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/common/widgets/widget_icon.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';
import 'package:spendsmart/core/helper/validators.dart';
import 'package:spendsmart/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authServiceProvider)
          .sendPasswordReset(emailController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset link sent! Please check your email inbox.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
        SizedBox(height: 8.h),
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
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.defaultPaddingh),
      child: WidgetButton(
        text: _isLoading ? 'Submitting...' : 'Submit',
        textColor: Colors.white,
        onPressed: _isLoading ? () {} : _handlePasswordReset,
        color: _isLoading ? Colors.grey : AppColors.primary,
      ),
    );
  }
}
