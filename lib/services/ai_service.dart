import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/models/bill_model.dart';
import 'package:spendsmart/models/goal_model.dart';
import 'package:spendsmart/models/transaction_model.dart';
import 'package:spendsmart/providers/bill_provider.dart';
import 'package:spendsmart/providers/envelop_provider.dart';
import 'package:spendsmart/services/goal_service.dart';
import '../../models/envelope_model.dart';

class AIService {
  final String _apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? "";
  final String _url = "https://openrouter.ai/api/v1/chat/completions";

  Future<String> getBudgetTip({
    required List<EnvelopeModel> envelopes,
    required List<TransactionModel> transactions,
    required List<BillModel> bills,
    required List<GoalModel> goals,
  }) async {
    if (envelopes.isEmpty && bills.isEmpty)
      return "Set up a budget to get started!";

    // Summarize Spending Envelopes
    final envelopeStatus = envelopes
        .map((e) => "${e.name}: ₱${e.remainingAmount}/${e.budgetAmount}")
        .join(", ");

    // Summarize Bill Status (New Logic)
    final unpaidBills = bills.where((b) => !b.isPaid).toList();
    final billStatus = unpaidBills.isEmpty
        ? "All bills paid!"
        : unpaidBills
              .map((b) => "${b.name} (Due Day ${b.dueDate.day}): ₱${b.amount}")
              .join(", ");

    final recentTx = transactions
        .take(10)
        .map((t) => "- ₱${t.amount} on ${t.productName}")
        .join("\n");

    final daysLeft =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day -
        DateTime.now().day;

    final goalSummary = goals
        .map((g) {
          double percent = (g.currentAmount / g.targetAmount) * 100;
          return "${g.title} (${percent.toStringAsFixed(0)}% done)";
        })
        .join(", ");

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          // "model": "openai/gpt-4o-mini"
          "model": "openai/gpt-5-mini",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a strategic financial coach. Provide EXACTLY ONE sentence (Max 15 words). "
                  "Analyze if recent spending velocity threatens upcoming bills or long-term goals. "
                  "Do not suggest topping up unless a balance is ₱0; instead, compare spending to goal progress. "
                  "Be direct and prioritize goal achievement over full envelopes.",
            },
            {
              "role": "user",
              "content":
                  "Envelopes: $envelopeStatus. Bills: $billStatus. Goals: $goalSummary. Days left in month: $daysLeft. Recent: $recentTx",
            },
          ],
          "max_completion_tokens": 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      }
      return "Keep an eye on those upcoming bills!";
    } catch (e) {
      return "Stay focused on your financial goals!";
    }
  }
}

final aiServiceProvider = Provider((ref) => AIService());

final aiTipProvider = FutureProvider<String>((ref) async {
  // Watch all four data streams
  final envelopes = ref.watch(envelopesStreamProvider).value ?? [];
  final bills = ref.watch(allBillsStreamProvider).value ?? [];
  final transactions = ref.watch(allTransactionsStreamProvider).value ?? [];
  final goals = ref.watch(goalsStreamProvider).value ?? []; // Add this

  return ref
      .read(aiServiceProvider)
      .getBudgetTip(
        envelopes: envelopes,
        bills: bills,
        transactions: transactions,
        goals: goals, // Pass goals here
      );
});
