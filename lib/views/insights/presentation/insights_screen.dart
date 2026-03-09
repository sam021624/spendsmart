import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/models/envelope_model.dart';
import 'package:spendsmart/providers/bill_provider.dart';
import 'package:spendsmart/providers/envelop_provider.dart';
import 'package:spendsmart/services/ai_service.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envelopesAsync = ref.watch(envelopesStreamProvider);
    final billsAsync = ref.watch(allBillsStreamProvider);
    final aiTipAsync = ref.watch(aiTipProvider);

    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(
          text: "AI Insights",
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.h,
          children: [
            aiTipAsync.when(
              data: (tip) => _buildAICoachCard(tip),
              loading: () => _buildAICoachCard("Analyzing your budget..."),
              error: (e, _) => _buildAICoachCard("Stay focused on your goals!"),
            ),
            const WidgetText(
              text: "Spending Breakdown",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),

            envelopesAsync.when(
              data: (envelopes) => _buildSpendingChart(envelopes),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const SizedBox(),
            ),
            SizedBox(height: 4.h),
            const WidgetText(
              text: "Smart Suggestions",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),

            envelopesAsync.when(
              data: (envelopes) => billsAsync.when(
                data: (bills) {
                  final urgentBills = bills
                      .where(
                        (b) =>
                            !b.isPaid &&
                            b.dueDate.difference(DateTime.now()).inDays <= 3,
                      )
                      .toList();

                  final lowEnvelopes = envelopes
                      .where(
                        (e) =>
                            (e.remainingAmount / e.budgetAmount) < 0.1 &&
                            e.remainingAmount > 0,
                      )
                      .toList();

                  return Column(
                    children: [
                      if (urgentBills.isNotEmpty)
                        _buildSuggestionCard(
                          title: "Pay ${urgentBills.first.name} soon",
                          subtitle:
                              "It's due in ${urgentBills.first.dueDate.difference(DateTime.now()).inDays} days. Don't miss it!",
                          icon: Ionicons.alert_circle,
                          color: Colors.redAccent,
                        ),

                      if (lowEnvelopes.isNotEmpty)
                        _buildSuggestionCard(
                          title: "Slow down on ${lowEnvelopes.first.name}",
                          subtitle:
                              "You only have ₱${lowEnvelopes.first.remainingAmount.toInt()} left in this category.",
                          icon: Ionicons.trending_down,
                          color: Colors.orange,
                        ),

                      if (urgentBills.isEmpty && lowEnvelopes.isEmpty)
                        _buildSuggestionCard(
                          title: "Budget is Healthy",
                          subtitle:
                              "You're on track to hit your goals this month. Keep it up!",
                          icon: Ionicons.checkmark_done_circle,
                          color: Colors.green,
                        ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => WidgetText(
                  text: "Error loading bills",
                  textColor: Colors.red,
                ),
              ),
              loading: () => const SizedBox(),
              error: (e, _) => const SizedBox(),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAICoachCard(String tip) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Ionicons.sparkles, color: Colors.deepPurple),
              SizedBox(width: 8.w),
              WidgetText(
                text: "SpendSmart AI",
                fontWeight: FontWeight.bold,
                textColor: Colors.deepPurple,
                fontSize: 12.sp,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          WidgetText(
            text: "\"$tip\"",
            fontSize: 14.sp,
            fontStyle: FontStyle.italic,
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingChart(List<EnvelopeModel> envelopes) {
    if (envelopes.isEmpty) return const SizedBox();

    EnvelopeModel highestSpendingEnv = envelopes.reduce(
      (a, b) =>
          (a.budgetAmount - a.remainingAmount) >
              (b.budgetAmount - b.remainingAmount)
          ? a
          : b,
    );

    double totalSpent = envelopes.fold(
      0,
      (sum, e) => sum + (e.budgetAmount - e.remainingAmount),
    );

    return Column(
      spacing: 8.h,
      children: [
        _buildHighestSpenderCard(highestSpendingEnv),
        SizedBox(
          height: 150.h,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40.r,
              sections: envelopes.map((e) {
                final spent = e.budgetAmount - e.remainingAmount;
                final displayValue = spent > 0 ? spent : 0.1;

                return PieChartSectionData(
                  color: _getCategoryColor(e.name),
                  value: displayValue,
                  title: totalSpent > 0
                      ? "${((spent / totalSpent) * 100).toStringAsFixed(0)}%"
                      : "",
                  radius: 50.r,
                  titleStyle: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        Wrap(
          spacing: 10.w,
          runSpacing: 5.h,
          children: envelopes.map((e) => _buildLegendItem(e.name)).toList(),
        ),
      ],
    );
  }

  Widget _buildHighestSpenderCard(EnvelopeModel env) {
    double spent = env.budgetAmount - env.remainingAmount;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Ionicons.trending_up, color: Colors.red, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: WidgetText(
              text: "Highest Spending: ${env.name} (₱${spent.toInt()})",
              fontSize: 12.sp,
              textColor: Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String name) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: _getCategoryColor(name),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        WidgetText(text: name, fontSize: 10.sp),
      ],
    );
  }

  Color _getCategoryColor(String name) {
    final List<Color> colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.pink,
      Colors.cyan,
    ];
    return colors[name.length % colors.length];
  }

  Widget _buildSuggestionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24.sp),
        ),
        title: WidgetText(
          text: title,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.chevron_right, size: 20.sp, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
