import 'package:bloc/bloc.dart';
import '../models/expense_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dot_project_app/database.dart'; // Import your database helper

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final DatabaseHelper _databaseHelper;

  ExpenseBloc(this._databaseHelper) : super(ExpenseInitial()) {
    on<FetchExpenses>(_onFetchExpenses);
  }

  Future<void> _onFetchExpenses(
      FetchExpenses event, Emitter<ExpenseState> emit) async {
    try {
      final expenses = await _databaseHelper.fetchExpenses();
      emit(ExpenseLoaded(
        dailyExpense: expenses['dailyExpense']!,
        monthlyExpense: expenses['monthlyExpense']!,
      ));
    } catch (e) {
      emit(ExpenseError(message: e.toString()));
    }
  }
}
