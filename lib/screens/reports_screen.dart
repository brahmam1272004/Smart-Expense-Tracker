import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/expense_provider.dart';
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<ExpenseProvider>().transactions;
    final Map<String, double> categoryTotals = {};

    for (final transaction in transactions) {
      if (!transaction.isIncome) {
        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) +
                transaction.amount;
      }
    }

    if (categoryTotals.isEmpty) {
      return const Center(
        child: Text('No expenses to report yet.'),
      );
    }

    final total = categoryTotals.values.fold<double>(
      0,
      (sum, amount) => sum + amount,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Total Expenses: ₹${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ...categoryTotals.entries.map((entry) {
          final percentage = entry.value / total;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('₹${entry.value.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: percentage),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
