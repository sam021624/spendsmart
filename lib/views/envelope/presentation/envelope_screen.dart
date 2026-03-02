import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';
import 'package:spendsmart/models/envelope_model.dart';

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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24.w,
          right: 24.w,
          top: 20.h,
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
            SizedBox(height: 10.h),
            WidgetTextField(
              controller: amountController,
              hintText: 'Monthly Budget Amount',
              keyboardType: TextInputType.number,
              iconData: Ionicons.cash_outline,
            ),
            SizedBox(height: 20.h),
            WidgetButton(
              text: 'Save Envelope',
              onPressed: () async {
                final name = nameController.text.trim();
                final amount = double.tryParse(amountController.text) ?? 0.0;

                if (name.isNotEmpty && amount > 0) {
                  final service = ref.read(envelopeServiceProvider);
                  if (service != null) {
                    await service.addEnvelope(name, amount);
                    nameController.clear();
                    amountController.clear();
                    if (mounted) Navigator.pop(context);
                  }
                }
              },
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final envelopesAsync = ref.watch(envelopesStreamProvider);

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
                _buildTotalBalanceCard(totalBalance),
                SizedBox(height: 8.h),
                WidgetText(
                  text: "Spending Envelopes",
                  fontWeight: FontWeight.w600,
                ),

                ...envelopes.map((env) => _buildEnvelopeItem(env)),

                _buildAddEnvelopeCTA(),
                _buildAITip(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalBalanceCard(double balance) {
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
            text: "₱ ${balance.toStringAsFixed(2)}",
            textColor: Colors.white,
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 12.h),
          WidgetText(
            text: "₱ 0.00 Unallocated",
            fontSize: 12.sp,
            textColor: Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildEnvelopeItem(EnvelopeModel envelope) {
    double progress = envelope.budgetAmount > 0
        ? (envelope.remainingAmount / envelope.budgetAmount)
        : 0;
    return Container(
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
                textColor: Colors.grey,
                fontSize: 12.sp,
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: Colors.blue.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
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

  Widget _buildAITip() {
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
          const Expanded(
            child: WidgetText(
              text: "AI: Looking good! You haven't overspent today.",
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
