import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';
import 'package:spendsmart/core/helper/navigation_extension.dart';
import 'package:spendsmart/models/envelope_model.dart';
import 'package:spendsmart/services/ai_service.dart';
import 'package:spendsmart/services/auth_service.dart';
import 'package:spendsmart/views/bills/presentation/bills_screen.dart';
import 'package:spendsmart/views/envelope/presentation/envelope_detail_screen.dart';

import '../../../providers/envelop_provider.dart';

class EnvelopeScreen extends ConsumerStatefulWidget {
  const EnvelopeScreen({super.key});

  @override
  ConsumerState<EnvelopeScreen> createState() => _EnvelopeScreenState();
}

class _EnvelopeScreenState extends ConsumerState<EnvelopeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _showCreateEnvelopeModal() {
    bool isBill = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => StatefulBuilder(
        // Added this to make Checkbox work
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetText(
                text: "Create Envelope",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 16.h),
              WidgetTextField(
                controller: nameController,
                iconData: Ionicons.pricetag_outline,
                hintText: 'Envelope Name (e.g. Food)',
              ),
              SizedBox(height: 8.h),
              WidgetTextField(
                controller: amountController,
                hintText: 'Monthly Budget Amount',
                keyboardType: TextInputType.number,
                iconData: Ionicons.cash_outline,
              ),
              // The Checkbox Row
              Row(
                children: [
                  Checkbox(
                    value: isBill,
                    onChanged: (val) {
                      setModalState(
                        () => isBill = val!,
                      ); // Use setModalState here
                    },
                  ),
                  const WidgetText(text: "Is this a Monthly Bill?"),
                ],
              ),
              SizedBox(height: 16.h),
              WidgetButton(
                text: 'Save Envelope',
                onPressed: () async {
                  final name = nameController.text.trim();
                  final amount = double.tryParse(amountController.text) ?? 0.0;

                  if (name.isNotEmpty && amount > 0) {
                    final service = ref.read(envelopeServiceProvider);
                    if (service != null) {
                      await service.addEnvelope(
                        name: name,
                        amount: amount,
                        type: isBill ? 'bill' : 'spending',
                        dueDate: isBill ? DateTime.now() : null,
                      );
                      nameController.clear();
                      amountController.clear();
                      if (context.mounted) Navigator.pop(context);
                    }
                  }
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final envelopesAsync = ref.watch(envelopesStreamProvider);
    final userAsync = ref.watch(userDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(
          text: "My Envelopes",
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Ionicons.notifications_outline),
          ),
        ],
      ),
      body: envelopesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text("Error loading envelopes: $err")),
        data: (envelopes) {
          double totalBalance = envelopes.fold(
            0,
            (sum, env) => sum + env.remainingAmount,
          );

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              spacing: 8.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Wrap the balance card in userAsync.when to calculate unallocated
                userAsync.when(
                  data: (user) {
                    final income = user?.monthlyIncome ?? 0.0;
                    final allocated = envelopes.fold(
                      0.0,
                      (sum, e) => sum + e.budgetAmount,
                    );
                    final unallocated = income - allocated;

                    return _buildTotalBalanceCard(totalBalance, unallocated);
                  },
                  loading: () => _buildTotalBalanceCard(totalBalance, 0.0),
                  error: (_, __) => _buildTotalBalanceCard(totalBalance, 0.0),
                ),

                SizedBox(height: 8.h),
                WidgetText(
                  text: "Spending Envelopes",
                  fontWeight: FontWeight.w600,
                ),

                ...envelopes.map((env) => _buildEnvelopeItem(env)),

                _buildAddEnvelopeCTA(),
                _buildAITip(ref),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalBalanceCard(double totalAvailable, double unallocated) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WidgetText(text: "Total Available", textColor: Colors.white70),
          SizedBox(height: 8.h),
          WidgetText(
            text: "₱ ${totalAvailable.toStringAsFixed(2)}",
            textColor: Colors.white,
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 12.h),
          WidgetText(
            text: "₱ ${unallocated.toStringAsFixed(2)} Unallocated",
            fontSize: 12.sp,
            // If unallocated is negative, show red to warn user they over-budgeted
            textColor: unallocated < 0 ? Colors.redAccent : Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildEnvelopeItem(EnvelopeModel envelope) {
    double progress = envelope.budgetAmount > 0
        ? (envelope.remainingAmount / envelope.budgetAmount)
        : 0;

    Color progressColor = progress < 0.3 ? Colors.red : Colors.blue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (envelope.type == 'bill') {
            context.navigateTo(BillsScreen(envelopeId: envelope.id));
          } else {
            context.navigateTo(EnvelopeDetailScreen(envelope: envelope));
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            spacing: 8.h,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetText(text: envelope.name, fontWeight: FontWeight.bold),
                  WidgetText(
                    text:
                        "₱${envelope.remainingAmount.toInt()} / ₱${envelope.budgetAmount.toInt()}",
                    // Also changing the text color to red if low for better visibility
                    textColor: progress < 0.2 ? Colors.red : Colors.grey,
                    fontSize: 12.sp,
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8.h,
                  backgroundColor: progressColor.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor,
                  ), // Updated this
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddEnvelopeCTA() {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(16.r),
        dashPattern: const [6, 4],
      ),

      child: InkWell(
        onTap: _showCreateEnvelopeModal,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Ionicons.add, color: Colors.grey),
              SizedBox(width: 8.w),
              WidgetText(
                text: "Add New Envelope",
                textColor: Colors.grey,
                fontSize: 14.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAITip(WidgetRef ref) {
    final aiTipAsync = ref.watch(aiTipProvider);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.blue),
          SizedBox(width: 12.w),
          Expanded(
            child: aiTipAsync.when(
              data: (tip) => WidgetText(text: "AI: $tip", fontSize: 12.sp),
              loading: () =>
                  const WidgetText(text: "AI is thinking...", fontSize: 12),
              error: (err, _) => const WidgetText(
                text: "AI: Save some ₱ today!",
                fontSize: 12,
              ),
            ),
          ),
          // // Optional: Add a refresh button
          // IconButton(
          //   icon: Icon(Icons.refresh, size: 16.sp, color: Colors.blue),
          //   onPressed: () => ref.refresh(aiTipProvider),
          // ),
        ],
      ),
    );
  }
}
