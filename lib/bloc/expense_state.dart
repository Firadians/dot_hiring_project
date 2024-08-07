part of 'expense_bloc.dart';

sealed class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseLoaded extends ExpenseState {
  final double dailyExpense;
  final double monthlyExpense;

  const ExpenseLoaded({
    required this.dailyExpense,
    required this.monthlyExpense,
  });

  @override
  List<Object> get props => [dailyExpense, monthlyExpense];
}

final class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError({required this.message});

  @override
  List<Object> get props => [message];
}
