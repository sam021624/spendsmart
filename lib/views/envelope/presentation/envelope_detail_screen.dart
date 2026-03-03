import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';
import 'package:spendsmart/models/envelope_model.dart';
import 'package:spendsmart/providers/envelop_provider.dart';

class EnvelopeDetailScreen extends ConsumerWidget {
  final EnvelopeModel envelope;

  const EnvelopeDetailScreen({super.key, required this.envelope});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(
      transactionsStreamProvider(envelope.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: WidgetText(text: envelope.name, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.h,
          children: [
            _buildHeaderCard(),
            const WidgetText(
              text: "Transaction History",
              fontWeight: FontWeight.bold,
            ),
            Expanded(
              child: transactionsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  debugPrint("--- FIRESTORE ERROR ---");
                  debugPrint(err.toString());
                  debugPrint("-----------------------");

                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: WidgetText(
                        text:
                            "Index required. Check Debug Console for the link.",
                        textAlign: TextAlign.center,
                        textColor: Colors.red,
                      ),
                    ),
                  );
                },

                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Ionicons.receipt_outline,
                            size: 50.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10.h),
                          const WidgetText(
                            text: "No transactions yet",
                            textColor: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          child: const Icon(
                            Ionicons.arrow_down,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                        title: WidgetText(
                          text: tx.productName,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: WidgetText(
                          text: DateFormat('MMM d, hh:mm a').format(tx.date),
                          fontSize: 12.sp,
                          textColor: Colors.grey,
                        ),
                        trailing: WidgetText(
                          text: "- ₱${tx.amount.toStringAsFixed(2)}",
                          textColor: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    double progress = envelope.budgetAmount > 0
        ? (envelope.remainingAmount / envelope.budgetAmount)
        : 0;

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
          const WidgetText(
            text: "Remaining Balance",
            textColor: Colors.white70,
          ),
          SizedBox(height: 4.h),
          WidgetText(
            text: "₱ ${envelope.remainingAmount.toStringAsFixed(2)}",
            textColor: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetText(
                text: "Budget: ₱${envelope.budgetAmount.toInt()}",
                textColor: Colors.white,
                fontSize: 12.sp,
              ),
              WidgetText(
                text: "${(progress * 100).toInt()}% left",
                textColor: Colors.white,
                fontSize: 12.sp,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
