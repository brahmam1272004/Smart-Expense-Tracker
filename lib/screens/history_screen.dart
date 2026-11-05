import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/expense_provider.dart';
import 'transaction_detail_screen.dart';
import 'edit_expense_screen.dart';
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final transactions = provider.transactions.reversed.toList();
if (provider.isLoading) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

if (provider.errorMessage != null) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(provider.errorMessage!),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => provider.loadTransactions(),
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
    if (transactions.isEmpty) {
      return const Center(
        child: Text('No transactions yet.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final expense = transactions[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          TransactionDetailScreen(expense: expense),
    ),
  );
},
            leading: CircleAvatar(
              backgroundColor: expense.isIncome
                  ? Colors.green.shade100
                  : Colors.orange.shade100,
              child: Icon(
                expense.isIncome
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: expense.isIncome ? Colors.green : Colors.orange,
              ),
            ),
            title: Text(expense.description),
            subtitle: Text(
              '${expense.category} • ${expense.date.day}/${expense.date.month}/${expense.date.year}',
            ),
           trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${expense.isIncome ? '+' : '-'}₹${expense.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                     fontWeight: FontWeight.bold,
                    color: expense.isIncome ? Colors.green : Colors.red,
                  ),
                ),
                IconButton(
  icon: const Icon(Icons.edit, color: Colors.blue),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpenseScreen(expense: expense),
      ),
    );
  },
),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteTransaction(expense.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}