import 'package:bloc/bloc.dart';
import '../models/transaction_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dot_project_app/database.dart'; // Import your database helper

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final DatabaseHelper _databaseHelper;

  TransactionBloc(this._databaseHelper) : super(TransactionInitial()) {
    on<FetchTransactions>(_onFetchTransactions);
  }

  Future<void> _onFetchTransactions(
      FetchTransactions event, Emitter<TransactionState> emit) async {
    try {
      final transactions = await _databaseHelper.fetchTransactions();
      emit(TransactionLoaded(transactions: transactions));
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }
}
