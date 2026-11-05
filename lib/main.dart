
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/expense.dart';
import 'services/expense_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ExpenseProvider()..loadTransactions(),
      child: const ExpenseTrackerApp(),
    ),
  );
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF246BFD),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const AddExpenseScreen(),
      const HistoryScreen(),
      const ReportsScreen(),
    ];

    final titles = ['Dashboard', 'Add Expense', 'History', 'Reports'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          titles[selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final Color background;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: background,
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 5),
          Text(
            amount,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final IconData icon;
  final Color color;

  const TransactionTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: amount.startsWith('+') ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}


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


class TransactionDetailScreen extends StatelessWidget {
  final Expense expense;

  const TransactionDetailScreen({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  expense.description,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Text(
                  '${expense.isIncome ? '+' : '-'} ₹${expense.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: expense.isIncome
                            ? colorScheme.primary
                            : colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Divider(height: 32),
                _detailRow('Type', expense.isIncome ? 'Income' : 'Expense'),
                _detailRow('Category', expense.category),
                _detailRow('Date', expense.date.toString().split(' ')[0]),
                _detailRow('Transaction ID', expense.id),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

