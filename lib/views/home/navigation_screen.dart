import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';
import 'package:spendsmart/providers/envelop_provider.dart';
import 'package:spendsmart/views/envelope/presentation/envelope_screen.dart';
import 'package:spendsmart/views/goal/presentation/goal_screen.dart';
import 'package:spendsmart/views/insights/presentation/insights_screen.dart';
import 'package:spendsmart/views/profile/presentation/profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const EnvelopeScreen(),
    const GoalsScreen(),
    const InsightsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTransactionModal(context);
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Ionicons.add, size: 30, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: AppColors.lightGrey,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _navItem(
                    Ionicons.wallet_outline,
                    Ionicons.wallet,
                    "Envelopes",
                    0,
                  ),
                  _navItem(Ionicons.star_outline, Ionicons.star, "Goals", 1),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _navItem(
                    Ionicons.analytics_outline,
                    Ionicons.analytics,
                    "Insights",
                    2,
                  ),
                  _navItem(
                    Ionicons.person_outline,
                    Ionicons.person,
                    "Profile",
                    3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, IconData activeIcon, String label, int index) {
    bool isActive = _selectedIndex == index;
    return MaterialButton(
      minWidth: 40,
      onPressed: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? AppColors.primary : Colors.grey,
          ),
          WidgetText(text: label, fontSize: 10.sp),
        ],
      ),
    );
  }

  void _showTransactionModal(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController productNameController = TextEditingController();
    String? selectedEnvelopeId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final envelopesAsync = ref.watch(envelopesStreamProvider);

          return Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.h,
              children: [
                WidgetText(
                  text: "Log Expense",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                WidgetTextField(
                  controller: amountController,
                  hintText: "0.00",
                  keyboardType: TextInputType.number,
                  iconData: Ionicons.cash_outline,
                ),

                envelopesAsync.when(
                  data: (envelopes) => DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Ionicons.wallet_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "Select Envelope",
                    ),
                    items: envelopes
                        .map(
                          (env) => DropdownMenuItem(
                            value: env.id,
                            child: Text(env.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => selectedEnvelopeId = val,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => const Text("Error loading envelopes"),
                ),
                WidgetTextField(
                  controller: productNameController,
                  hintText: "What did you buy? (e.g. Starbucks)",
                  iconData: Ionicons.create_outline,
                ),
                WidgetButton(
                  text: "Deduct from Envelope",
                  onPressed: () async {
                    final amount = double.tryParse(amountController.text) ?? 0;
                    if (selectedEnvelopeId != null && amount > 0) {
                      await ref
                          .read(envelopeServiceProvider)!
                          .addTransaction(
                            envelopeId: selectedEnvelopeId!,
                            amount: amount,
                            productName: productNameController.text,
                          );
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
