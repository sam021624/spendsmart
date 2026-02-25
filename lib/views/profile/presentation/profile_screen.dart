import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    WidgetText(
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

              const Text(
                "Income & Funding",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildFundingCard(context),

              const SizedBox(height: 24),

              Align(
                alignment: AlignmentGeometry.topLeft,
                child: const WidgetText(
                  text: "Preferences",
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingsTile(
                Ionicons.notifications_outline,
                Colors.black,
                "Notifications",
                Colors.black,
                "Alerts for overspending",
              ),
              _buildSettingsTile(
                Ionicons.shield_checkmark_outline,
                Colors.black,
                "Security",
                Colors.black,
                "Change Password",
              ),
              _buildSettingsTile(
                Ionicons.color_palette_outline,
                Colors.black,
                "Appearance",
                Colors.black,
                "Dark Mode & Themes",
              ),
              _buildSettingsTile(
                Ionicons.help_circle_outline,
                Colors.black,
                "Support",
                Colors.black,
                "Chat with us",
              ),

              _buildSettingsTile(
                Ionicons.exit_outline,
                AppColors.red,
                "Logout",
                AppColors.red,
                "Sign out of your account",
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
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

  Widget _buildSettingsTile(
    IconData icon,
    Color iconColor,
    String title,
    Color titleColor,
    String subtitle,
  ) {
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
      onTap: () {},
    );
  }
}
