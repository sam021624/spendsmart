import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/widgets/widget_snackbar.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/core/helper/navigation_extension.dart';
import 'package:spendsmart/core/services/auth_service.dart';
import 'package:spendsmart/views/onboarding/onboarding_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      await AuthService().signOut();

      if (context.mounted) {
        context.pushAndClear(OnboardingScreen());
        WidgetSnackbar.showSuccess(
          context: context,
          title: "Logged Out",
          message: "You have been successfully signed out.",
        );
      }
    } catch (e) {
      if (context.mounted) {
        WidgetSnackbar.showError(
          context: context,
          message: "Failed to log out. Please try again.",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const WidgetText(
                      text: "User Name",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    WidgetText(
                      text: "spending.smart@email.com",
                      textColor: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Income & Funding",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              _buildFundingCard(context),

              const SizedBox(height: 24),

              const Align(
                alignment: Alignment.topLeft,
                child: WidgetText(
                  text: "Preferences",
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              _buildSettingsTile(
                icon: Ionicons.notifications_outline,
                title: "Notifications",
                subtitle: "Alerts for overspending",
              ),
              _buildSettingsTile(
                icon: Ionicons.shield_checkmark_outline,
                title: "Security",
                subtitle: "Change Password",
              ),
              _buildSettingsTile(
                icon: Ionicons.color_palette_outline,
                title: "Appearance",
                subtitle: "Dark Mode & Themes",
              ),
              _buildSettingsTile(
                icon: Ionicons.help_circle_outline,
                title: "Support",
                subtitle: "Chat with us",
              ),

              _buildSettingsTile(
                icon: Ionicons.exit_outline,
                iconColor: AppColors.red,
                title: "Logout",
                titleColor: AppColors.red,
                subtitle: "Sign out of your account",
                onTap: () => _showLogoutDialog(context, ref),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: WidgetText(
          text: "Logout",
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        content: const WidgetText(text: "Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: WidgetText(text: "Cancel", fontSize: 12.sp),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout(context, ref);
            },
            child: WidgetText(
              text: "Logout",
              textColor: AppColors.red,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetText(text: "Ready to Assign"),
              WidgetText(
                text: "₱ 0.00",
                fontWeight: FontWeight.bold,
                fontSize: 18,
                textColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: WidgetText(
                text: "Deposit & Distribute Income",
                textColor: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    Color iconColor = Colors.black,
    required String title,
    Color titleColor = Colors.black,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: WidgetText(
        text: title,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        textColor: titleColor,
      ),
      subtitle: WidgetText(text: subtitle, fontSize: 10.sp),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap ?? () {},
    );
  }
}
