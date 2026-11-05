import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../services/expense_provider.dart';
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
String? amountError;
String? descriptionError;

String selectedCategory = 'Food';
bool isIncome = false;
DateTime selectedDate = DateTime.now();


  final categories = [
    'Food',
    'Shopping',
    'Travel',
    'Bills',
    'Health',
    'Education',
    'Other',
  ];

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

 Future<void> saveExpense() async {
  final amount = double.tryParse(amountController.text.trim());
final description = descriptionController.text.trim();

setState(() {
  amountError = (amount == null || amount <= 0)
      ? 'Enter a valid amount greater than 0'
      : null;

  descriptionError = description.isEmpty
      ? 'Please enter a description'
      : null;
});

if (amountError != null || descriptionError != null) {
  return;
}

  final expense = Expense(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    description: descriptionController.text.trim(),
    amount: amount!,
    category: selectedCategory,
    date: selectedDate,
    isIncome: isIncome,
  );

  await context.read<ExpenseProvider>().addTransaction(expense);

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
  content: Text(
    isIncome ? 'Income saved successfully!' : 'Expense saved successfully!',
  ),
),
  );

  amountController.clear();
  descriptionController.clear();

  setState(() {
    isIncome = false;
    selectedCategory = 'Food';
    selectedDate = DateTime.now();
  });
} 

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
  isIncome ? 'Add New Income' : 'Add New Expense',
  style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
), 
          const SizedBox(height: 8),
          Text(
            isIncome
    ? 'Enter the money you have received.'
    : 'Enter the money you have spent.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 25),

          const Text('Amount (₹)',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
  'Transaction Type',
  style: TextStyle(fontWeight: FontWeight.bold),
),
const SizedBox(height: 8),
SegmentedButton<bool>(
  segments: const [
    ButtonSegment(
      value: false,
      label: Text('Expense'),
    ),
    ButtonSegment(
      value: true,
      label: Text('Income'),
    ),
  ],
  selected: {isIncome},
  onSelectionChanged: (selection) {
    setState(() {
      isIncome = selection.first;
    });
  },
),
const SizedBox(height: 20),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              hintText: 'Enter amount',
              errorText: amountError,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text('Description',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Example: Lunch, Bus ticket',
              errorText: descriptionError,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text('Category',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            items: categories.map((category) {
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
          const Text('Date',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.calendar_month),
            label: Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
            ),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() => selectedDate = date);
              }
            },
          ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: saveExpense,
              icon: const Icon(Icons.save),
              label: Text(isIncome ? 'Save Income' : 'Save Expense'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF246BFD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}