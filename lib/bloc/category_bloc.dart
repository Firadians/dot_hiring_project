import 'package:bloc/bloc.dart';
import '../models/category_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dot_project_app/database.dart'; // Import your database helper

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final DatabaseHelper _databaseHelper;

  CategoryBloc(this._databaseHelper) : super(CategoryInitial()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
      FetchCategories event, Emitter<CategoryState> emit) async {
    try {
      final categories = await _databaseHelper.fetchCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}
