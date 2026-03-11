import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/widgets/widget_snackbar.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/core/helper/navigation_extension.dart';
import 'package:spendsmart/providers/auth_provider.dart';
import 'package:spendsmart/providers/envelop_provider.dart';
import 'package:spendsmart/views/onboarding/onboarding_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.pushAndClear(const OnboardingScreen());
        WidgetSnackbar.showSuccess(
          context: context,
          title: "Logged Out",
          message: "See you soon!",
        );
      }
    } catch (e) {
      if (context.mounted) {
        WidgetSnackbar.showError(context: context, message: "Logout failed.");
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the Typed User Model Provider
    final userAsync = ref.watch(userDataProvider);
    final envelopesAsync = ref.watch(envelopesStreamProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            spacing: 8.h,
            children: [
              userAsync.when(
                data: (user) => _buildUserHeader(
                  // Using user.username from the UserModel
                  name: user?.username ?? "User",
                  email: user?.email ?? "No Email Provided",
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    _buildUserHeader(name: "Error", email: "Try again later"),
              ),

              SizedBox(height: 4.h),

              const Align(
                alignment: Alignment.centerLeft,
                child: WidgetText(
                  text: "Income & Funding",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              userAsync.when(
                data: (user) {
                  // Using monthlyIncome from the UserModel
                  final totalIncome = user?.monthlyIncome ?? 0.0;

                  return envelopesAsync.when(
                    data: (envelopes) {
                      final allocated = envelopes.fold(
                        0.0,
                        (sum, e) => sum + e.budgetAmount,
                      );
                      final readyToAssign = totalIncome - allocated;
                      return _buildFundingCard(
                        context,
                        readyToAssign,
                        totalIncome,
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text("Error: $e"),
                  );
                },
                loading: () => const SizedBox(),
                error: (e, _) => const SizedBox(),
              ),

              SizedBox(height: 4.h),

              const Align(
                alignment: Alignment.topLeft,
                child: WidgetText(
                  text: "Preferences",
                  fontWeight: FontWeight.bold,
                ),
              ),

              _buildPreferencesTab(context, ref),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencesTab(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
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
          title: "Logs",
          subtitle: "Transaction Logs",
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
      ],
    );
  }

  Widget _buildUserHeader({required String name, required String email}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(Icons.person, size: 50.sp, color: AppColors.primary),
        ),
        SizedBox(height: 8.h),
        WidgetText(text: name, fontSize: 20.sp, fontWeight: FontWeight.bold),
        WidgetText(text: email, textColor: Colors.grey, fontSize: 12.sp),
      ],
    );
  }

  Widget _buildFundingCard(
    BuildContext context,
    double readyAmount,
    double totalIncome,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const WidgetText(text: "Ready to Assign"),
              WidgetText(
                text: "₱ ${readyAmount.toStringAsFixed(2)}",
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                textColor: readyAmount < 0 ? Colors.red : AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          WidgetButton(
            text: "Deposit Income",
            onPressed: () => _showDepositModal(context, totalIncome),
          ),
        ],
      ),
    );
  }

  void _showDepositModal(BuildContext context, double currentIncome) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          left: 20.w,
          right: 20.w,
          top: 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WidgetText(
              text: "Add Monthly Income",
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10.h),
            WidgetTextField(
              controller: controller,
              hintText: "Enter amount (e.g. 5000)",
              keyboardType: TextInputType.number,
              iconData: Ionicons.cash_outline,
            ),
            SizedBox(height: 20.h),
            WidgetButton(
              text: "Add to Funds",
              onPressed: () async {
                final amount = double.tryParse(controller.text) ?? 0;
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null && amount > 0) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({'monthlyIncome': currentIncome + amount});
                  if (context.mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const WidgetText(text: "Logout", fontWeight: FontWeight.bold),
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
              textColor: Colors.red,
              fontSize: 12.sp,
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
      onTap: onTap,
    );
  }
}
