import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';

class EnvelopeScreen extends StatelessWidget {
  const EnvelopeScreen({super.key});

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
}
