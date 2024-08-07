import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final double dailyExpense;
  final double monthlyExpense;

  const Expense({
    required this.dailyExpense,
    required this.monthlyExpense,
  });

  @override
  List<Object> get props => [dailyExpense, monthlyExpense];
}
