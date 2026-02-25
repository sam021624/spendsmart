import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const WidgetText(text: "Savings Goals")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Total Saved Summary
          _buildGoalSummaryCard(),

          const SizedBox(height: 24),

          // 2. Active Goals List
          _buildGoalCard(
            context,
            title: "Travel to Cebu",
            current: 1500,
            target: 5000,
            icon: Ionicons.airplane,
            color: Colors.teal,
            deadline: "Dec 2026",
          ),

          _buildGoalCard(
            context,
            title: "New Laptop",
            current: 800,
            target: 45000,
            icon: Ionicons.laptop,
            color: Colors.indigo,
            deadline: "Ongoing",
          ),

          // 3. Add New Goal Placeholder
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Create a New Goal"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSummaryCard() {
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
      child: const Column(
        children: [
          Text("Total Savings", style: TextStyle(color: Colors.white70)),
          Text(
            "₱ 2,300.00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context, {
    required String title,
    required double current,
    required double target,
    required IconData icon,
    required Color color,
    required String deadline,
  }) {
    double progress = current / target;
    int percentage = (progress * 100).toInt();

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
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetText(
                      text: title,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    WidgetText(
                      text: "Target: $deadline",
                      textColor: Colors.grey,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
              WidgetText(
                text: "$percentage%",
                textColor: color,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₱$current",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("₱$target", style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
