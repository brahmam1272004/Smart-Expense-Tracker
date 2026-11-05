import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/services/expense_provider.dart';
void main() {
  testWidgets('Expense Tracker dashboard loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ExpenseProvider(),
        child: const ExpenseTrackerApp(),
      ),
    );

    expect(find.text('Dashboard'), findsOneWidget);
  });
}