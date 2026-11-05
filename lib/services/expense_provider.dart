import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _transactions = [];

  List<Expense> get transactions => _transactions;

  double get totalIncome => _transactions
      .where((e) => e.isIncome)
      .fold(0, (sum, e) => sum + e.amount);

  double get totalExpenses => _transactions
      .where((e) => !e.isIncome)
      .fold(0, (sum, e) => sum + e.amount);

  double get balance => totalIncome - totalExpenses;

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadTransactions() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('transactions');

      if (savedData != null) {
        final List<dynamic> decoded = jsonDecode(savedData);
        _transactions = decoded
            .map((item) => Expense.fromJson(item))
            .toList();
      } else {
        _transactions = [];
      }
    } catch (e) {
      errorMessage = 'Unable to load transactions. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Expense expense) async {
    _transactions.add(expense);
    await saveTransactions();
    notifyListeners();
  }

  Future<void> saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(
      _transactions.map((e) => e.toJson()).toList(),
    );
    await prefs.setString('transactions', data);
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((e) => e.id == id);
    await saveTransactions();
    notifyListeners();
  }

  Future<void> updateTransaction(Expense updatedExpense) async {
    final index = _transactions.indexWhere(
      (e) => e.id == updatedExpense.id,
    );

    if (index != -1) {
      _transactions[index] = updatedExpense;
      await saveTransactions();
      notifyListeners();
    }
  }
}