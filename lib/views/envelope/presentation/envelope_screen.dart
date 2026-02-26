import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';

class EnvelopeScreen extends StatefulWidget {
  const EnvelopeScreen({super.key});

  @override
  State<EnvelopeScreen> createState() => _EnvelopeScreenState();
}

class _EnvelopeScreenState extends State<EnvelopeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void _showCreateEnvelopeModal(BuildContext context) {
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.h,
          children: [
            WidgetText(
              text: "Create Envelope",
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            WidgetTextField(
              controller: nameController,
              iconData: Ionicons.pricetag_outline,
              hintText: 'Envelope Name',
            ),
            WidgetTextField(
              controller: amountController,
              hintText: 'Budget Amount',
              keyboardType: TextInputType.number,
              iconData: Ionicons.cash_outline,
            ),
            WidgetButton(text: 'Save Envelope', onPressed: () {}),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(text: "My Envelopes"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Ionicons.notifications_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Total Overview Card
            _buildTotalBalanceCard(),

            const SizedBox(height: 24),

            // 2. Section Header
            const WidgetText(text: "Spending Envelopes"),
            const SizedBox(height: 12),

            // 3. The Envelope List
            _buildEnvelopeItem("Bills", 500, 500, Colors.blue),
            _buildEnvelopeItem("Food", 120, 300, Colors.orange),
            _buildEnvelopeItem("Accessories", 50, 200, Colors.purple),
            _buildAddEnvelopeCTA(),

            const SizedBox(height: 24),

            // 4. AI Insight Tip (Small teaser for your Insights tab)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.blue, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: WidgetText(
                      text:
                          "AI Tip: You're spending on Food faster than usual this week!",
                      textColor: Colors.blue,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black, // Dark theme for the main card looks premium
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetText(text: "Total Available", textColor: Colors.white),
          SizedBox(height: 8),
          WidgetText(
            text: "₱ 1,000.00",
            textColor: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 12),
          WidgetText(
            text: "₱ 0.00 Unallocated",
            fontSize: 12.sp,
            textColor: Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildEnvelopeItem(
    String title,
    double remaining,
    double total,
    Color color,
  ) {
    double progress = remaining / total;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetText(
                text: title,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              WidgetText(
                text: "₱$remaining / ₱$total",
                textColor: Colors.grey,
                fontSize: 12.sp,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddEnvelopeCTA() {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(16.sp),
        color: Colors.grey.withAlpha(150),
        strokeWidth: 2,
        dashPattern: const [6, 4],
      ),

      child: InkWell(
        onTap: () => _showCreateEnvelopeModal(context),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Ionicons.add, color: Colors.grey, size: 20.sp),
              SizedBox(width: 8.w),
              WidgetText(
                text: "Add New Envelope",
                textColor: Colors.grey,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
