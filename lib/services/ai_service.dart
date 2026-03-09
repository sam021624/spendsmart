import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/models/bill_model.dart';
import 'package:spendsmart/models/transaction_model.dart';
import 'package:spendsmart/providers/bill_provider.dart';
import 'package:spendsmart/providers/envelop_provider.dart';
import '../../models/envelope_model.dart';

class AIService {
  final String _apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? "";
  final String _url = "https://openrouter.ai/api/v1/chat/completions";

  Future<String> getBudgetTip({
    required List<EnvelopeModel> envelopes,
    required List<TransactionModel> transactions,
    required List<BillModel> bills,
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

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          // "model": "openai/gpt-4o-mini", // Note: Ensure model name is correct
          "model": "openai/gpt-5-mini",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a concise financial coach. Provide EXACTLY ONE short sentence of advice (Max 15 words). "
                  "Priority: If unpaid bills are due soon, warn the user. Otherwise, suggest saving based on spending. "
                  "Use ₱ directly without intro phrases.",
            },
            {
              "role": "user",
              "content":
                  "Envelopes: $envelopeStatus. \nUnpaid Bills: $billStatus. \nRecent: $recentTx",
            },
          ],
          "max_completion_tokens":
              50, // Reduced for faster response and lower cost
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
  final envelopes = ref.watch(envelopesStreamProvider).value ?? [];
  final bills = ref.watch(allBillsStreamProvider).value ?? [];
  final transactions = ref.watch(allTransactionsStreamProvider).value ?? [];

  return ref
      .read(aiServiceProvider)
      .getBudgetTip(
        envelopes: envelopes,
        bills: bills, // Pass the new separate bills list
        transactions: transactions,
      );
});
