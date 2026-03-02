import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/models/goal_model.dart';
import 'package:spendsmart/services/goal_service.dart';
import 'package:spendsmart/views/goal/widgets/goal_modals.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(
          text: "Savings Goals",
          fontWeight: FontWeight.bold,
        ),
      ),
      body: goalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (goals) {
          double totalSaved = goals.fold(0, (sum, g) => sum + g.currentAmount);

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildGoalSummaryCard(totalSaved),
              const SizedBox(height: 8),

              ...goals.map((goal) => _buildGoalCard(context, goal)),

              const SizedBox(height: 8),
              _buildCreateGoalButton(context, ref),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGoalSummaryCard(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const WidgetText(text: "Total Savings", textColor: AppColors.white),
          WidgetText(
            text: "₱ ${total.toStringAsFixed(2)}",
            textColor: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, GoalModel goal) {
    double progress = goal.targetAmount > 0
        ? goal.currentAmount / goal.targetAmount
        : 0;
    int percentage = (progress * 100).toInt();
    Color goalColor = Color(goal.colorValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: goalColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IconData(
                    goal.iconCode,
                    fontFamily: 'Ionicons',
                    fontPackage: 'ionicons',
                  ),
                  color: goalColor,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetText(
                      text: goal.title,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    WidgetText(
                      text: "Target: ${goal.deadline}",
                      textColor: Colors.grey,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
              WidgetText(
                text: "$percentage%",
                textColor: goalColor,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(goalColor),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₱${goal.currentAmount.toInt()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "₱${goal.targetAmount.toInt()}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateGoalButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () => GoalModals.showCreateGoalModal(context, ref),
      icon: const Icon(Icons.add),
      label: const Text("Create a New Goal"),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
