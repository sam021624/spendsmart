import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const WidgetText(text: "AI Insights")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. AI Coach Header
            _buildAICoachCard(),

            const SizedBox(height: 24),

            // 2. Spending Breakdown (Visual)
            const WidgetText(
              text: "Spending Breakdown",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            _buildSpendingChartPlaceholder(), // In a real app, use 'fl_chart' package

            const SizedBox(height: 24),

            // 3. AI Suggestions (The "Actionable" part)
            WidgetText(
              text: "Smart Suggestions",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            _buildSuggestionCard(
              title: "Move ₱150 to Travel",
              subtitle:
                  "You have leftover funds in 'Accessories' from last month.",
              icon: Ionicons.arrow_forward_circle,
              color: Colors.green,
            ),
            _buildSuggestionCard(
              title: "Slow down on 'Food'",
              subtitle:
                  "You've used 80% of this envelope, but the month is only 40% over.",
              icon: Ionicons.alert_circle,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAICoachCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Ionicons.sparkles, color: Colors.deepPurple),
              SizedBox(width: 10),
              WidgetText(
                text: "SpendSmart AI",
                fontWeight: FontWeight.bold,
                textColor: Colors.deepPurple,
                fontSize: 12.sp,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const WidgetText(
            text:
                "\"At your current pace, you'll hit your 'Travel to Cebu' goal 5 days early! Keep it up.\"",
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingChartPlaceholder() {
    // This represents where a PieChart or BarChart would go
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Ionicons.pie_chart, size: 50, color: Colors.grey),
            WidgetText(
              text: "Visual Chart: Bills (50%), Food (30%), Acc (20%)",
              textColor: Colors.grey,
              fontSize: 12.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: WidgetText(text: title, fontWeight: FontWeight.bold),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
