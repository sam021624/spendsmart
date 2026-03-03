import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/models/transaction_model.dart';
import 'package:spendsmart/providers/envelop_provider.dart';
import '../../models/envelope_model.dart';

class AIService {
  final String _apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? "";
  final String _url = "https://openrouter.ai/api/v1/chat/completions";

  Future<String> getBudgetTip({
    required List<EnvelopeModel> envelopes,
    required List<TransactionModel> transactions,
  }) async {
    if (envelopes.isEmpty) return "Create an envelope to get started!";

    final envelopeStatus = envelopes
        .map(
          (e) => "${e.name}: ₱${e.remainingAmount} left of ₱${e.budgetAmount}",
        )
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
          "model": "openai/gpt-5-mini",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a concise financial coach. "
                  "Analyze the data and provide EXACTLY ONE short sentence of advice. "
                  "Maximum 12 words. Do not use introductory phrases like 'Based on your spending...' "
                  "Just give the tip directly. Use ₱.",
            },
            {
              "role": "user",
              "content":
                  "Balances: $envelopeStatus. \nRecent Spending:\n$recentTx",
            },
          ],
          "max_completion_tokens": 700,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      }
      return "Keep tracking those expenses!";
    } catch (e) {
      return "AI is taking a break. You're doing great!";
    }
  }
}

final aiServiceProvider = Provider((ref) => AIService());

final aiTipProvider = FutureProvider<String>((ref) async {
  final envelopes = ref.watch(envelopesStreamProvider).value ?? [];
  final transactions = ref.watch(allTransactionsStreamProvider).value ?? [];

  return ref
      .read(aiServiceProvider)
      .getBudgetTip(envelopes: envelopes, transactions: transactions);
});
