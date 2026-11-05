import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/expense_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          const Text(
            'Your Financial Overview',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF246BFD), Color(0xFF6638D5)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  '₹${provider.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Icon(Icons.account_balance_wallet,
                        color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Your money at a glance',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Income',
                  amount: '₹${provider.totalIncome.toStringAsFixed(2)}',
                  icon: Icons.trending_up,
                  color: const Color(0xFF16A36A),
                  background: const Color(0xFFE2F7ED),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Expenses',
                  amount: '₹${provider.totalExpenses.toStringAsFixed(2)}',
                  icon: Icons.trending_down,
                  color: const Color(0xFFE34D59),
                  background: const Color(0xFFFFE8EA),
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (provider.transactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Text('No transactions yet. Add your first transaction!'),
              ),
            )
          else
            ...provider.transactions.reversed.take(5).map((expense) {
              return TransactionTile(
                title: expense.description,
                date:
                    '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                amount:
                    '${expense.isIncome ? '+' : '-'}₹${expense.amount.toStringAsFixed(2)}',
                icon: Icons.receipt_long,
                color: expense.isIncome ? Colors.green : Colors.orange,
              );
            }),
        ],
      ),
    );
  }
}
