import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';
import 'package:spendsmart/services/goal_service.dart';

class GoalModals {
  static void showCreateGoalModal(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WidgetText(
              text: "Set a New Goal",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),

            WidgetTextField(
              controller: titleController,
              hintText: "Goal Title (e.g. Dream House)",
              iconData: Ionicons.trophy_outline,
            ),
            const SizedBox(height: 12),

            WidgetTextField(
              controller: amountController,
              hintText: "How much do you need?",
              keyboardType: TextInputType.number,
              iconData: Ionicons.cash_outline,
            ),
            const SizedBox(height: 12),

            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2035),
                );

                if (pickedDate != null) {
                  dateController.text =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
              child: AbsorbPointer(
                child: WidgetTextField(
                  controller: dateController,
                  hintText: "Target Date (DD/MM/YYYY)",
                  iconData: Ionicons.calendar_outline,
                ),
              ),
            ),
            const SizedBox(height: 24),

            WidgetButton(
              text: "Create Goal",
              onPressed: () async {
                final title = titleController.text;
                final target = double.tryParse(amountController.text) ?? 0;
                final date = dateController.text;

                if (title.isNotEmpty && target > 0 && date.isNotEmpty) {
                  await ref
                      .read(goalServiceProvider)
                      ?.createGoal(
                        title: title,
                        target: target,
                        deadline: date,
                        iconCode: Ionicons.star.codePoint,
                        color: Colors.indigo,
                      );
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
