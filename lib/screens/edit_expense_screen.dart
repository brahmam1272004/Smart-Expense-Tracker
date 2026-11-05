import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../services/expense_provider.dart';
class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController descriptionController;
  late TextEditingController amountController;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    descriptionController =
        TextEditingController(text: widget.expense.description);
    amountController =
        TextEditingController(text: widget.expense.amount.toString());
    selectedCategory = widget.expense.category;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    final description = descriptionController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (description.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid details')),
      );
      return;
    }

    final updatedExpense = Expense(
      id: widget.expense.id,
      description: description,
      amount: amount,
      category: selectedCategory,
      date: widget.expense.date,
      isIncome: widget.expense.isIncome,
    );

    await context.read<ExpenseProvider>().updateTransaction(updatedExpense);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              items: [
                'Food',
                'Shopping',
                'Travel',
                'Bills',
                'Health',
                'Education',
                'Other',
              ].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Update Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}