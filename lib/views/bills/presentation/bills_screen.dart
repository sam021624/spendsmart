import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/widgets/widget_button.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/common/widgets/widget_text_field.dart';
import 'package:spendsmart/core/helper/date_formatter.dart';
import 'package:spendsmart/models/bill_model.dart';
import 'package:spendsmart/providers/bill_provider.dart';

class BillsScreen extends ConsumerWidget {
  final String envelopeId;

  const BillsScreen({super.key, required this.envelopeId});

  void _showCreateBillModal(BuildContext context, WidgetRef ref) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      helpText: "Select Bill Due Date",
    );

    if (pickedDate == null) return;

    final nameController = TextEditingController();
    final amountController = TextEditingController();

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetText(
                text: "Bill Details",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 4.h),
              WidgetText(
                text: "Due on: ${formatDate(pickedDate)}",
                textColor: Colors.blue,
                fontSize: 12.sp,
              ),
              SizedBox(height: 16.h),
              WidgetTextField(
                controller: nameController,
                hintText: 'Bill Name (e.g. Electricity)',
                iconData: Ionicons.receipt_outline,
              ),
              SizedBox(height: 12.h),
              WidgetTextField(
                controller: amountController,
                hintText: 'Amount Due',
                keyboardType: TextInputType.number,
                iconData: Ionicons.cash_outline,
              ),
              SizedBox(height: 24.h),
              WidgetButton(
                text: 'Save Bill',
                onPressed: () async {
                  final name = nameController.text.trim();
                  final amount = double.tryParse(amountController.text) ?? 0.0;

                  if (name.isNotEmpty && amount > 0) {
                    final service = ref.read(billServiceProvider);
                    if (service != null) {
                      await service.addBill(
                        name: name,
                        amount: amount,
                        dueDate: pickedDate,
                        envelopeId: envelopeId,
                      );
                      if (context.mounted) Navigator.pop(context);
                    } else {
                      debugPrint(
                        "Service is null - User might not be logged in",
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid name and amount"),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  void _confirmPayment(BuildContext context, WidgetRef ref, BillModel bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const WidgetText(
          text: "Confirm Payment",
          fontWeight: FontWeight.bold,
        ),
        content: WidgetText(
          text:
              "Mark ${bill.name} as paid? ₱${bill.amount} will be deducted from your envelope balance.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const WidgetText(text: "Cancel", textColor: AppColors.red),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.pop(context);

              final service = ref.read(billServiceProvider);
              if (service != null) {
                await service.payBill(bill: bill);
                // Feedback for the user
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: WidgetText(text: "${bill.name} marked as paid!"),
                    ),
                  );
                }
              }
            },
            child: const WidgetText(
              text: "Confirm",
              textColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsStreamProvider(envelopeId));

    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(
          text: "Monthly Bills",
          fontWeight: FontWeight.bold,
        ),
      ),
      body: billsAsync.when(
        data: (bills) {
          if (bills.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.receipt_outline,
                    size: 64.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  const WidgetText(
                    text: "No bills added yet.",
                    textColor: Colors.grey,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: bills.length,
            itemBuilder: (context, index) =>
                _buildBillCard(context, ref, bills[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBillModal(context, ref),
        label: const WidgetText(text: "Add Bill", textColor: AppColors.white),
        icon: const Icon(Ionicons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildBillCard(BuildContext context, WidgetRef ref, BillModel bill) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: WidgetText(text: bill.name, fontWeight: FontWeight.bold),
        subtitle: WidgetText(
          text: bill.isPaid
              ? "Status: Paid ✅"
              : "Due: ${formatDate(bill.dueDate)}",
          textColor: bill.isPaid ? Colors.green : Colors.orange,
          fontSize: 12.sp,
        ),
        trailing: bill.isPaid
            ? const Icon(Icons.check_circle, color: Colors.green)
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () => _confirmPayment(context, ref, bill),
                child: WidgetText(
                  text: "Pay ₱${bill.amount.toInt()}",
                  fontSize: 12.sp,
                  textColor: Colors.white,
                ),
              ),
      ),
    );
  }
}
